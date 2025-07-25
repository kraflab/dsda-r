require 'test_helper'

class PlayersCreateTest < ActionDispatch::IntegrationTest
  def setup
    @admin = admins(:elim)
    @params = {
      player: {
        name: 'Bram Stoker',
        username: 'dracula',
        twitch: 'vampire',
        youtube: 'bramstoker'
      }
    }
    @wrong_params = { player: @params[:player].merge(name: nil) }
    setup_auth_headers
  end

  test 'authenticated player upload' do
    post '/api/players/', params: @params, as: :json, headers: @headers
    created_player = Player.find_by(name: 'Bram Stoker')
    assert created_player.present?
    response_hash = JSON.parse(response.body)
    assert_equal response_hash['name'], created_player.name
    assert_equal response_hash['username'], created_player.username
  end

  test 'invalid player upload' do
    post '/api/players/', params: @wrong_params, as: :json, headers: @headers
    assert_nil Player.find_by(name: 'Bram Stoker')
    assert_equal response.status, 422
    assert_includes response.body, '"name":["can\'t be blank"]'
  end

  test 'unauthenticated player upload' do
    post '/api/players/', params: @params, as: :json, headers: @wrong_headers
    assert_nil Player.find_by(name: 'Bram Stoker')
    assert_equal response.status, 401
    assert_includes response.body, 'Unauthorized'
  end
end
