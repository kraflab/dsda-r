class PlayersController < ApplicationController
  autocomplete :player, :username
  skip_before_action :verify_authenticity_token, only: [:api_create]
  before_action :authenticate_admin!, only: [:api_create]

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

  def api_create
    preprocess_api_request(require: [:player])
    player = PlayerCreationService.new(@request_hash[:player]).create!
    render json: PlayerSerializer.new(player).call
  end
end
