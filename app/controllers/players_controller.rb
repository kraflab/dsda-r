class PlayersController < ApplicationController
  def show
    @player = Player.find_by(username: params[:id])
  end
  
  def index
    @players = Player.all
  end
  
  def new
  end
end
