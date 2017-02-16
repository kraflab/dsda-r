class PlayersController < ApplicationController
  before_action :admin_session, except: [:index, :show]
  
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
    Player.find_by(username: params[:id]).destroy
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
    
    # Confirms an admin session
    def admin_session
      unless logged_in?
        flash[:warning] = "You must be logged in to perform this action"
        redirect_to(root_url)
      end
    end
end
