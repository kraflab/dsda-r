require 'test_helper'

class PlayersUpdateTest < ActionDispatch::IntegrationTest
  def setup
    @player = players(:elim)
    @admin = admins(:elim)
    @unauthorized_admin = admins(:bob)
    @params = {
      player_update: {
        username: 'elim2'
      }
    }
    @wrong_params = { player_update: @params[:player_update].merge(username: 'a b c d') }
    setup_auth_headers
  end

  test 'authenticated player update' do
    patch '/api/players/elim', params: @params, as: :json, headers: @headers
    @player.reload
    assert_equal @player.username, 'elim2'
    response_hash = JSON.parse(response.body)
    assert response_hash['save']
    assert_equal response_hash['player']['id'], @player.id
  end

  test 'invalid player update' do
    patch '/api/players/elim', params: @wrong_params, as: :json, headers: @headers
    assert_equal @player.username, @player.reload.username
    assert_equal response.status, 422
    assert_includes response.body, '"username"'
  end

  test 'unauthenticated player update' do
    patch '/api/players/elim', params: @params, as: :json, headers: @wrong_headers
    assert_equal @player.username, @player.reload.username
    assert_equal response.status, 401
    assert_includes response.body, 'Unauthorized'
  end

  test 'unauthorized player update' do
    patch '/api/players/elim', params: @params, as: :json, headers: @unauthorized_headers
    assert_equal @player.username, @player.reload.username
    assert_equal response.status, 401
    assert_includes response.body, 'Unauthorized'
  end
end
