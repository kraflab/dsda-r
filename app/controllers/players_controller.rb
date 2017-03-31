class PlayersController < ApplicationController
  autocomplete :player, :username
  before_action :admin_session, except: [:index, :show, :api_show]
  before_action :age_limit, only: :destroy
  
  def api_show
    query = params[:query].nil? ? nil : JSON.parse(CGI::unescape(params[:query]))
    if query
      if query['mode'] == 'fixed'
        player = Player.find_by(username: query['id']) || Player.find_by(name: query['id'])
      else
        player = Player.reorder('RANDOM()').first
      end
      response_hash = {}
      response_hash[:error_message] = []
      response_hash[:error_message].push "Player not found" if player.nil?
      commands = query['commands']
      if player
        commands.each do |command, detail|
          case command
          when 'count'
            detail.each do |d|
              case d
              when 'demos'
                response_hash[:demo_count] ||= player.demos.count
              when 'wads'
                response_hash[:wad_count] ||= DemoPlayer.where(player: player).includes(:demo).select("demos.wad_id").references(:demo).distinct.count
              when 'tas'
                response_hash[:tas_count] ||= DemoPlayer.where(player: player).includes(:demo).where("demos.tas > 0").references(:demo).count
              else
                response_hash[:error_messages].push "Unknown Player Count '#{d}'"
              end
            end
          when 'stats'
            response_hash[:longest_demo] = Demo.tics_to_string(player.demos.maximum(:tics))
            response_hash[:total_time], response_hash[:average_time] = time_stats(player, false)
            response_hash[:demo_count] ||= player.demos.count
            response_hash[:wad_count] ||= DemoPlayer.where(player: player).includes(:demo).select("demos.wad_id").references(:demo).distinct.count

            # group wads by number of demos by this player, get average / max
            wad_counts = DemoPlayer.where(player: player).includes(:demo).group("demos.wad_id").references(:demo).count
            top_wad = Wad.find(wad_counts.max_by { |k, v| v }[0])
            response_hash[:average_demo_count] = wad_counts.keys.inject { |sum, k| sum + k } / wad_counts.size
            response_hash[:top_wad] = top_wad.name
            
            # group demos by category
            category_counts = DemoPlayer.where(player: player).includes(:demo).group("demos.category_id").references(:demo).count
            top_category = Category.find(category_counts.max_by { |k, v| v }[0])
            response_hash[:top_category] = top_category.name
            
            response_hash[:tas_count] ||= DemoPlayer.where(player: player).includes(:demo).where("demos.tas > 0").references(:demo).count
          when 'properties'
            response_hash[:player] = player.serializable_hash(only: [:name, :username, :twitch, :youtube])
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
    @players = Player.all
  end
  
  def show
    @player = Player.find_by(username: params[:id])
    @demos  = @player.demos.includes(:wad).reorder("wads.username",
                                                   :level, :category_id, :tics)
  end
  
  def new
    @player = Player.new
  end
  
  def create
    these_params = check_username(player_params)
    @player = Player.new(these_params)
    if @player.save
      flash[:info] = "Player successfully created"
      redirect_to player_path(@player)
    else
      render 'new'
    end
  end
  
  def destroy
    @player.destroy
    flash[:info] = "Player successfully deleted"
    redirect_to players_url
  end
  
  def edit
    @player = Player.find_by(username: params[:id])
    @old_username = @player.username
  end
  
  def update
    @old_username = params[:player][:old_username]
    @player = Player.find_by(username: @old_username)
    params[:player][:username] = @player.username if @player.is_frozen?
    these_params = check_username(player_params)
    if @player.update_attributes(these_params)
      flash[:info] = "Player successfully updated"
      redirect_to @player
    else
      render 'edit'
    end
  end
  
  private
  
    def player_params
      params.require(:player).permit(:name, :username, :twitch, :youtube)
    end
    
    # Insert default username construction if none provided
    def check_username(these_params)
      if these_params[:username].empty?
        these_params[:username] = Player.default_username(these_params[:name])
      end
      these_params
    end
    
    # Allows destroy only for new items
    def age_limit
      @player = Player.find_by(username: params[:id])
      if @player.is_frozen?
        flash[:warning] = "That Player is too old to delete from here"
        redirect_to root_url
      end
    end
    
    # Confirms an admin session
    def admin_session
      unless logged_in?
        flash[:warning] = "You must be logged in to perform this action"
        redirect_to root_url
      end
    end
end
