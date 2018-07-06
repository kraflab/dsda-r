class PlayersController < ApplicationController
  autocomplete :player, :username
  skip_before_action :verify_authenticity_token, only: [:api_create]
  before_action :authenticate_admin!, only: [:api_create]

  def index
    @players = Domain::Player.list
  end

  def show
    @player = Domain::Player.single(username: params[:id], assert: true)
    @demos  = @player.demos.includes(:wad).reorder('wads.username',
                                                   :level, :category_id, :tics)
  end

  def stats
    @player = Domain::Player.single(username: params[:id], assert: true)
  end

  def api_create
    preprocess_api_request(require: [:player])
    player = Domain::Player.create(@request_hash[:player])
    render json: PlayerSerializer.new(player).call
  end
end
