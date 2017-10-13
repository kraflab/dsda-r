class PlayersController < ApplicationController
  autocomplete :player, :username
  before_action :admin_session, only: [:new, :create, :edit, :update, :destroy]
  before_action :age_limit, only: :destroy
  skip_before_action :verify_authenticity_token, only: [:api_create]

  def index
    @players = Player.all
  end

  def show
    @player = Player.find_by(username: params[:id])
    @demos  = @player.demos.includes(:wad).reorder('wads.username',
                                                   :level, :category_id, :tics)
  end

  def stats
    @player = Player.find_by(username: params[:id])
  end

  def new
    @player = Player.new
  end

  def api_create
    query, response_hash, admin = preprocess_api_authenticate(request)
    # admin is nil unless authentication was successful
    if query and admin
      player_query = query['player']
      @player = Player.new(player_query.slice('name', 'username', 'twitch',
                                                                  'youtube'))
      if @player.save
        response_hash[:save] = true
        response_hash[:player] = {id: @player.id, username: @player.username}
      else
        response_hash[:error_message].push 'Player creation failed', *@player.errors
      end
    end
    response_hash[:error] = (response_hash[:error_message].count > 0)
    render json: response_hash
  end

  def create
    these_params = check_username(player_params)
    @player = Player.new(these_params)
    if @player.save
      flash[:info] = 'Player successfully created'
      redirect_to player_path(@player)
    else
      render 'new'
    end
  end

  def destroy
    @player.destroy
    flash[:info] = 'Player successfully deleted'
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
      flash[:info] = 'Player successfully updated'
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
        flash[:warning] = 'That Player is too old to delete from here'
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
