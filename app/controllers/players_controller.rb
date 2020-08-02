class PlayersController < ApplicationController
  autocomplete :player, :username
  skip_before_action :verify_authenticity_token, only: [:api_create, :api_update]
  before_action :authenticate_admin!, only: [:api_create, :api_update]

  ALLOWED_UPDATE_PARAMS = [
    :name,
    :username,
    :alias,
    :cheater,
    :twitch,
    :youtube
  ].freeze

  def index
    @players = Domain::Player.list
  end

  def show
    @player = Domain::Player.single(username: params[:id], assert: true)
    @demos  = @player.demos
                     .includes(:players)
                     .includes(:category)
                     .includes(:demo_file)
                     .includes(:wad)
                     .reorder('wads.short_name', :level, :category_id, :tics)
  end

  def record_view
    @player = Domain::Player.single(username: params[:id], assert: true)
    @demos  = @player.demos
                     .only_records
                     .includes(:players)
                     .includes(:category)
                     .includes(:demo_file)
                     .includes(:wad)
                     .reorder('wads.short_name', :level, :category_id, :tics)
  end

  def history
    @player = Domain::Player.single(username: params[:id], assert: true)
    @demos  = @player.demos
                     .includes(:players)
                     .includes(:category)
                     .includes(:demo_file)
                     .includes(:wad)
                     .reorder(recorded_at: :desc)
                     .order('wads.short_name', :level, :category_id, :tics)
  end

  def stats
    @player = Domain::Player.single(username: params[:id], assert: true)
  end

  def api_create
    AdminAuthorizer.authorize!(@current_admin, :create)

    preprocess_api_request(require: [:player])
    player = Domain::Player.create(@request_hash[:player])
    render json: PlayerSerializer.new(player).call
  end

  def api_update
    AdminAuthorizer.authorize!(@current_admin, :update)

    preprocess_api_request(require: [:player_update])
    player = Domain::Player.single(username: params[:id], assert: true)
    params = @request_hash[:player_update].slice(*ALLOWED_UPDATE_PARAMS)
    Domain::Player.update(params.merge(id: player.username))
    render json: PlayerSerializer.new(player.reload).call
  end
end
