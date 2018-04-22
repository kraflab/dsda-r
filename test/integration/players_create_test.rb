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
    @headers = {
      'HTTP_API_USERNAME' => @admin.username,
      'HTTP_API_PASSWORD' => 'password1234'
    }
    @wrong_headers = {
      'HTTP_API_USERNAME' => @admin.username,
      'HTTP_API_PASSWORD' => 'password5678'
    }
  end

  test 'authenticated player upload' do
    post '/api/players/', params: @params, as: :json, headers: @headers
    created_player = Player.find_by(name: 'Bram Stoker')
    assert created_player.present?
    response_hash = JSON.parse(response.body)
    assert response_hash['save']
    assert_equal response_hash['player']['id'], created_player.id
    assert_equal response_hash['player']['username'], created_player.username
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
