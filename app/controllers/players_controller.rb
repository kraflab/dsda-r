class PlayersController < ApplicationController
  def index
    @players = Player.all
  end
  
  def show
    @player = Player.find_by(username: params[:id])
  end
  
  def new
    @player = Player.new
  end
end
