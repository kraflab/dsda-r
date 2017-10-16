class PlayersController < ApplicationController
  autocomplete :player, :username
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

  private

  # Insert default username construction if none provided
  def check_username(these_params)
    if these_params[:username].empty?
      these_params[:username] = Player.default_username(these_params[:name])
    end
    these_params
  end
end
