class DemosController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:api_create]

  def feed
    @sort_sym = params[:sort_by] == 'record_date' ? :recorded_at : :updated_at
    @demos = Demo.reorder(@sort_sym => :desc).page params[:page]
  end

  def api_create
    query, response_hash, admin = preprocess_api_authenticate(request)
    # admin is nil unless authentication was successful
    if query and admin
      demo_query = query['demo']
      players, player_errors = parse_players(demo_query['players'], true)
      if player_errors.empty?
        @demo= Demo.new(demo_query.slice('time', 'tas', 'guys', 'level', 'recorded_at', 'levelstat', 'engine', 'version', 'wad_username', 'category_name', 'video_link'))
        if @demo.valid?
          success = true
          if has_file_data?(demo_query)
            io = Base64StringIO.new(Base64.decode64(demo_query['file']['data']))
            io.original_filename = demo_query['file']['name'][0..23]
            new_file = DemoFile.new(wad: @demo.wad)
            new_file.data = io
            if new_file.save
              @demo.demo_file = new_file
            else
              success = false
              response_hash[:error_message].push 'Demo creation failed', *new_file.errors
            end
          elsif demo_query['file_id']
            if demo_file = DemoFile.find_by(id: demo_query['file_id'])
              @demo.demo_file = demo_file
            else
              success = false
              response_hash[:error_message].push 'Demo creation failed', 'file not found'
            end
          end
          if success
            @demo.save
            players.each do |player|
              DemoPlayer.create(demo: @demo, player: player)
            end
            parse_tags(demo_query['tags'])
            response_hash[:save] = true
            response_hash[:demo] = {id: @demo.id, file_id: @demo.demo_file_id}
          end
        else
          response_hash[:error_message].push 'Demo creation failed', *@demo.errors
        end
      else
        response_hash[:error_message].push 'Demo creation failed', *player_errors
      end
    end
    response_hash[:error] = (response_hash[:error_message].count > 0)
    render json: response_hash
  end

  def hidden_tag
    demo = Demo.find(params[:id])
    render plain: demo.hidden_tags_text
  end

  private

  def parse_tags_form(tags, checks)
    tag_list = []

    # hack to get around empty check boxes
    checks.each_with_index do |c, i|
      if c == 'No'
        if i < checks.size and checks[i + 1] == 'Yes'
          tag_list.push({'text' => tags.shift, 'style' => '1'})
        else
          tag_list.push({'text' => tags.shift, 'style' => '0'})
        end
      end
    end

    parse_tags(tag_list)
  end

  def parse_tags(tags)
    return if tags.nil?

    tags.each do |tag|
      next if tag['text'].blank?
      sub_category = SubCategory.find_by(name: tag['text']) ||
                     SubCategory.create(name: tag['text'], show: tag['style'])
      Tag.create(sub_category: sub_category, demo: @demo) if sub_category
    end
  end

  def parse_players(player_names, from_api = false)
    players = []
    errors  = []
    if from_api and player_names.nil?
      errors.push('No player list')
    else
      player_names.each do |name|
        next if name.blank?
        player = Player.find_by(username: name) || Player.find_by(name: name)
        player.nil? ? errors.push((from_api ? 'Missing player: ' : '') + name.to_s) : players.push(player)
      end
    end
    [players, errors]
  end
end
