class WadsController < ApplicationController
  before_action :admin_session, only: [:new, :create, :destroy, :edit, :update]
  before_action :age_limit, only: :destroy
  
  def api_show
    response_hash = {}
    response_hash[:error_message] = []
    query = JSON.parse(request.headers["HTTP_API"])
    if query
      if query['mode'] == 'fixed'
        wad = Wad.find_by(username: query['id']) || Wad.find_by(name: query['id'])
      else
        wad = Wad.reorder('RANDOM()').first
      end
      response_hash[:error_message].push "Wad not found" if wad.nil?
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
                response_hash[:error_message].push "No record exists"
              else
                response_hash[:demo] = {time: demo.time, player: demo.players.first.username}
              end
            else
              response_hash[:error_message].push "Wad Record requires level and category"
            end
          when 'count'
            detail.each do |d|
              case d
              when 'demos'
                response_hash[:demo_count] ||= wad.demos.count
              when 'players'
                response_hash[:player_count] ||= DemoPlayer.includes(:demo).where("demos.wad_id = ?", wad.id).references(:demo).select(:player_id).distinct.count
              else
                response_hash[:error_messages].push "Unknown Wad Count '#{d}'"
              end
            end
          when 'stats'
            response_hash[:longest_demo] = Demo.tics_to_string(wad.demos.maximum(:tics))
            response_hash[:total_time], response_hash[:average_time] = time_stats(wad, false)
            response_hash[:demo_count] ||= wad.demos.count
            response_hash[:player_count] ||= DemoPlayer.includes(:demo).where("demos.wad_id = ?", wad.id).references(:demo).select(:player_id).distinct.count
            
            # group players by number of demos for this wad, get max
            player_counts = DemoPlayer.includes(:demo).where("demos.wad_id = ?", wad.id).references(:demo).group(:player_id).count
            top_player = Player.find(player_counts.max_by { |k, v| v }[0])
            response_hash[:top_player] = top_player.name
          when 'properties'
            response_hash[:wad] = wad.serializable_hash(only: [:name, :username, :author, :year, :compatibility, :is_commercial, :versions, :single_map], methods: :iwad_username)
          end
        end
      end
    else
      response_hash[:error_message].push 'No command given'
    end
    response_hash[:error] = (response_hash[:error_message].count > 0)
    render json: response_hash
  end
  
  def index
    letter = params[:letter]
    if (/\A[a-z9]\z/ =~ letter) == 0
      if letter == "9"
        @wads = Rails.env.production? ?
          Wad.where("username ~ ?", "^[0-9]") :
          Wad.where("username REGEXP ?", "^[0-9]")
      else
        @wads = Wad.where("username LIKE ?", "#{letter}%")
      end
    else
      @wads = Wad.paginate(page: params[:page])
      @is_paginated = true
    end
  end
  
  def show
    @wad = Wad.find_by(username: params[:id])
    @demos = @wad.demos
  end
  
  def new
    @wad = Wad.new
    @wad.iwad_username = params[:iwad] if params[:iwad]
  end
  
  def create
    @wad = Wad.new(wad_params)
    if @wad.save
      flash[:info] = "Wad successfully created"
      redirect_to wad_path(@wad)
    else
      render 'new'
    end
  end
  
  def destroy
    @wad.destroy
    flash[:info] = "Wad successfully deleted"
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
      flash[:info] = "Wad successfully updated"
      redirect_to @wad
    else
      if @wad.iwad.nil?
        @wad.errors.add(:iwad_username, :not_found, message: "not found")
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
  
  private
  
    def wad_params
      params[:wad][:single_map] = (params[:wad][:single_map] == '1')
      params.require(:wad).permit(:name, :username, :author, :file, :iwad_username, :single_map)
    end
    
    # Allows destroy only for new items
    def age_limit
      @wad = Wad.find_by(username: params[:id])
      if @wad.is_frozen?
        flash[:warning] = "That Wad is too old to delete from here"
        redirect_to root_url
      end
    end
    
    # Confirms an admin session
    def admin_session
      unless logged_in?
        flash[:warning] = "You must be logged in to perform this action"
        redirect_to(root_url)
      end
    end
end
