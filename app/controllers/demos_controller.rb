class DemosController < ApplicationController
  before_action :admin_session, except: [:feed, :api_create, :latest, :hidden_tag]
  before_action :age_limit, only: :destroy
  skip_before_action :verify_authenticity_token, only: [:api_create]
  
  def feed
    @demos = Demo.reorder(created_at: :desc).page params[:page]
  end
  
  def latest
    @demos = Demo.reorder(created_at: :desc).page
    @latest = @demos.first
    if stale? @latest
      respond_to do |format|
        format.atom
      end
    end
  end
  
  def new
    @demo = Demo.new
    @demo.wad_username = params[:wad] if params[:wad]
  end
  
  # TODO - refactor the creation code with the create action!
  def api_create
    response_hash = {}
    response_hash[:error_message] = []
    query = JSON.parse(request.body.read)
    if query
      admin, code = authenticate_admin(request.headers["HTTP_API_USERNAME"], request.headers["HTTP_API_PASSWORD"])
      if admin
        case code
        when ADMIN_ERR_LOCK
          response_hash[:error_message].push 'This account has been locked; contact kraflab'
        when ADMIN_SUCCESS
          demo_query = query['demo']
          players, player_errors = parse_players(demo_query['players'], true)
          if player_errors.empty?
            @demo= Demo.new(demo_query.slice('time', 'tas', 'guys', 'level', 'recorded_at', 'levelstat', 'engine', 'version', 'wad_username', 'category_name', 'video_link'))
            if @demo.valid?
              success = true
              if demo_query['file'] and demo_query['file']['data'] and demo_query['file']['name']
                io = Base64StringIO.new(Base64.decode64(demo_query['file']['data']))
                io.original_filename = demo_query['file']['name'][0..15]
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
        when ADMIN_ERR_FAIL
          response_hash[:error_message].push 'Invalid username/password combination'
        end
      else
        response_hash[:error_message].push 'Invalid username/password combination'
      end
    else
      response_hash[:error_message].push 'No command given'
    end
    response_hash[:error] = (response_hash[:error_message].count > 0)
    render json: response_hash
  end
  
  def create
    players, player_errors = parse_players(params[:players])
    if player_errors.empty?
      @demo = Demo.new(demo_params)
      if @demo.save
        players.each do |player|
          DemoPlayer.create(demo: @demo, player: player)
        end
        parse_tags_form(params[:tags], params[:shows])
        flash[:info] = 'Demo successfully created'
        redirect_to wad_path(@demo.wad)
      else
        render 'new'
      end
    else
      @demo = Demo.new(demo_params)
      flash.now[:warning] = "Players: #{errors.join(", ")} not found"
      render 'new'
    end
  end
  
  def destroy
    @demo.destroy
    flash[:info] = 'Demo successfully deleted'
    redirect_to root_path
  end
  
  def hidden_tag
    demo = Demo.find(params[:id])
    render plain: demo.hidden_tags_text
  end
  
  def edit
    @demo = Demo.find(params[:id])
  end
  
  def update
    @demo = Demo.find(params[:id])
    players, errors = parse_players(params[:players])
    if errors.empty?
      if @demo.update(demo_params)
        demo_players = @demo.demo_players
        demo_players.each { |dp| dp.destroy }
        demo_tags = @demo.tags
        demo_tags.each { |dt| dt.destroy }
        players.each do |player|
          DemoPlayer.create(demo: @demo, player: player).save
        end
        parse_tags_form(params[:tags], params[:shows])
        flash[:info] = 'Demo successfully updated'
        redirect_to wad_path(@demo.wad)
      else
        render 'edit'
      end
    else
      flash.now[:warning] = "Players: #{errors.join(", ")} not found"
      render 'edit'
    end
  end
  
  private
    
    def demo_params
      params.require(:demo).permit(:guys, :tas, :level, :time, :engine,
                                   :levelstat, :wad_username, :category_name,
                                   :recorded_at)
    end
    
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
    
    # Allows destroy only for new items
    def age_limit
      @demo = Demo.find(params[:id])
      if @demo.is_frozen?
        flash[:warning] = 'That Demo is too old to delete from here'
        redirect_to root_url
      end
    end
    
    # Confirms an admin session
    def admin_session
      unless logged_in?
        flash[:warning] = 'You must be logged in to perform this action'
        redirect_to root_url
      end
    end
end
