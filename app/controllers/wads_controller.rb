class WadsController < ApplicationController
  before_action :admin_session, only: [:new, :create, :destroy, :edit, :update]
  before_action :age_limit, only: :destroy
  skip_before_action :verify_authenticity_token, only: [:api_create]

  def api_show
    query, response_hash = preprocess_api(request)
    if query
      if query['mode'] == 'fixed'
        wad = Wad.find_by(username: query['id']) || Wad.find_by(name: query['id'])
      else
        wad = Wad.reorder('RANDOM()').first
      end
      response_hash[:error_message].push 'Wad not found' if wad.nil?
      commands = query['commands']
      if wad
        commands.each do |command, detail|
          case command
          when 'record'
            level = detail['level']
            category = detail['category']
            if level and category
              demo = wad.demos.where(tas: 0, guys: 1, level: level, category: Category.find_by(name: category)).first
              if demo.nil?
                response_hash[:error_message].push 'No record exists'
              else
                response_hash[:demo] = {time: demo.time, player: demo.players.first.username}
              end
            else
              response_hash[:error_message].push 'Wad Record requires level and category'
            end
          when 'count'
            detail.each do |d|
              case d
              when 'demos'
                response_hash[:demo_count] ||= wad.demos.count
              when 'players'
                response_hash[:player_count] ||= DemoPlayer.includes(:demo).where('demos.wad_id = ?', wad.id).references(:demo).select(:player_id).distinct.count
              else
                response_hash[:error_messages].push "Unknown Wad Count '#{d}'"
              end
            end
          when 'stats'
            # This function puts the results directly into the hash
            wad_stats(wad, response_hash)
          when 'properties'
            response_hash[:wad] = wad.serializable_hash(only: [:name, :username, :author, :year, :compatibility, :is_commercial, :versions, :single_map], methods: :iwad_username)
          end
        end
      end
    end
    response_hash[:error] = (response_hash[:error_message].count > 0)
    render json: response_hash
  end

  def index
    letter = params[:letter]
    if (/\A[a-z9]\z/ =~ letter) == 0
      if letter == '9'
        @wads = Rails.env.production? ?
          Wad.where('username ~ ?', '^[0-9]') :
          Wad.where('username REGEXP ?', '^[0-9]')
      else
        @wads = Wad.where('username LIKE ?', "#{letter}%")
      end
    else
      @wads = Wad.page params[:page]
      @is_paginated = true
    end
  end

  def show
    @wad = Wad.find_by(username: params[:id])
    subset = params[:level]
    @demos = subset.nil? ? @wad.demos : @wad.demos.where(level: subset)
  end

  def stats
    @wad = Wad.find_by(username: params[:id])
  end

  def new
    @wad = Wad.new
    @wad.iwad_username = params[:iwad] if params[:iwad]
  end

  # TODO - refactor with demo creation api
  def api_create
    query, response_hash, admin = preprocess_api_authenticate(request)
    # admin is nil unless authentication was successful
    if query and admin
      wad_query = query['wad']
      iwad = Iwad.find_by(name: wad_query['iwad']) || Iwad.find_by(username: wad_query['iwad'])
      if iwad
        @wad = Wad.new(wad_query.slice('name', 'username', 'author', 'year',
                                       'compatibility', 'is_commercial', 'single_map'))
        @wad.iwad = iwad
        if @wad.valid?
          success = true
          if has_file_data?(wad_query)
            io = Base64StringIO.new(Base64.decode64(wad_query['file']['data']))
            io.original_filename = wad_query['file']['name'][0..23]
            new_file = WadFile.new(iwad: @wad.iwad)
            new_file.data = io
            if new_file.save
              @wad.wad_file = new_file
            else
              success = false
              response_hash[:error_message].push 'Wad creation failed', *new_file.errors
            end
          elsif wad_query['file_id']
            if wad_file = WadFile.find_by(id: wad_query['file_id'])
              @wad.wad_file = wad_file
            else
              success = false
              response_hash[:error_message].push 'Wad creation failed', 'file not found'
            end
          end
          if success
            @wad.save
            response_hash[:save] = true
            response_hash[:wad] = {id: @wad.id, file_id: @wad.wad_file_id}
          end
        else
          response_hash[:error_message].push 'Wad creation failed', *@wad.errors
        end
      else
        response_hash[:error_message].push 'Wad creation failed', 'Iwad not found'
      end
    end
    response_hash[:error] = (response_hash[:error_message].count > 0)
    render json: response_hash
  end

  def create
    @wad = Wad.new(wad_params)
    if @wad.save
      flash[:info] = 'Wad successfully created'
      redirect_to wad_path(@wad)
    else
      render 'new'
    end
  end

  def destroy
    @wad.destroy
    flash[:info] = 'Wad successfully deleted'
    redirect_to wads_url
  end

  def edit
    @wad = Wad.find_by(username: params[:id])
    @old_username = @wad.username
  end

  def update
    @old_username  = params[:wad][:old_username]
    @wad = Wad.find_by(username: @old_username)
    params[:wad][:username] = @wad.username if @wad.is_frozen?
    if @wad.update_attributes(wad_params)
      flash[:info] = 'Wad successfully updated'
      redirect_to @wad
    else
      if @wad.iwad.nil?
        @wad.errors.add(:iwad_username, :not_found, message: 'not found')
      end
      render 'edit'
    end
  end

  def record_timeline_json
    @wad = Wad.find_by(username: params[:id])
    level = params[:level]
    category = Category.find_by(name: params[:category])
    demos = Demo.where(level: level, category: category, wad: @wad, guys: 1, tas: 0).reorder(:recorded_at)
    data_full = demos.all.map { |i| [i.players.first.username, i.tics, i.time, i.recorded_at] }
    if data_full.empty?
      render json: {data: [], players: [], error: true}
    else
      data_final = [data_full[0]]
      data_full.each do |datum|
        if datum[1] < data_final[-1][1]
          data_final.push(datum)
        end
      end
      plot = {data: [], players: {}, error: false}
      data_final.each do |datum|
        plot[:data].push({x: datum[3].to_s, y: datum[1]})
        plot[:players]["#{datum[1]}"] = datum[0]
      end
      render json: plot
    end
  end

  def record_timeline
    @wad = Wad.find_by(username: params[:id])
    @level = params[:level]
    @category = params[:category]
  end

  def compare_movies_json
    wad = Wad.find_by(username: params[:id])
    level = params[:level]
    category = params[:category]
    index_0 = params[:index_0].to_i
    index_1 = params[:index_1].to_i
    demos = Demo.where(level: level, category: Category.find_by(name: category), wad: wad, guys: 1, tas: 0)
    demo_0 = demos[index_0]
    demo_1 = demos[index_1]
    if level.nil? or !level.include?('Ep') or demo_0.nil? or demo_1.nil?
      render json: {error: true}
    end
    render json: {error: false,
                  times: compare_movies_pairs(demo_0, demo_1)}
  end

  def compare_movies
    @wad = Wad.find_by(username: params[:id])
    @level = params[:level]
    @category = params[:category]
    @demos = Demo.where(level: @level, category: Category.find_by(name: @category), wad: @wad, guys: 1, tas: 0)
    if @level.nil? or !@level.include?('Ep') or @demos.count < 2
      if @wad.nil?
        flash[:info] = 'Wad not found'
        redirect_to root_url
      else
        flash[:info] = 'A movie comparison is not possible for these parameters'
        redirect_to wad_url(@wad)
      end
    end
  end

  private

    def wad_params
      params[:wad][:single_map] = (params[:wad][:single_map] == '1')
      params.require(:wad).permit(:name, :username, :author, :file, :iwad_username, :single_map)
    end

    # Allows destroy only for new items
    def age_limit
      @wad = Wad.find_by(username: params[:id])
      if @wad.is_frozen?
        flash[:warning] = 'That Wad is too old to delete from here'
        redirect_to root_url
      end
    end

    # Confirms an admin session
    def admin_session
      unless logged_in?
        flash[:warning] = 'You must be logged in to perform this action'
        redirect_to(root_url)
      end
    end
end
