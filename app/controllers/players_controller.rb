class PlayersController < ApplicationController
  before_action :admin_session, except: [:index, :show]
  def index
    @players = Player.all
  end
  
  def show
    @player = Player.find_by(username: params[:id])
  end
  
  def new
    @player = Player.new
  end
  
  private
    
    # Confirms an admin session
    def admin_session
      unless logged_in?
        flash[:warning] = "You must be logged in to perform this action"
        redirect_to(root_url)
      end
    end
end
