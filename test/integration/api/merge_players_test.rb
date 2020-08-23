require 'test_helper'

class MergePlayersTest < ActionDispatch::IntegrationTest
  def setup
    @from = players(:kraflab)
    @into = players(:elim)
    @demo_count = @from.demos.count + @into.demos.count
    @admin = admins(:elim)
    @unauthorized_admin = admins(:bob)
    @params = {
      merge_players: {
        from: @from.username,
        into: @into.username
      }
    }
    @wrong_params = { merge_players: { from: @from.username } }
    setup_auth_headers
  end

  test 'authenticated player merge' do
    post '/api/merge_players', params: @params, as: :json, headers: @headers
    assert_equal Player.find_by(username: @from.username), nil
    assert_equal @demo_count, @into.reload.demos.count
    response_hash = JSON.parse(response.body)
    assert response_hash['merged']
  end

  test 'invalid player merge' do
    post '/api/merge_players', params: @wrong_params, as: :json, headers: @headers
    assert Player.find_by(username: @from.username).present?
    assert_equal response.status, 404
  end

  test 'unauthenticated player merge' do
    post '/api/merge_players', params: @params, as: :json, headers: @wrong_headers
    assert Player.find_by(username: @from.username).present?
    assert_equal response.status, 401
    assert_includes response.body, 'Unauthorized'
  end

  test 'unauthorized player merge' do
    post '/api/merge_players', params: @params, as: :json, headers: @unauthorized_headers
    assert Player.find_by(username: @from.username).present?
    assert_equal response.status, 401
    assert_includes response.body, 'Unauthorized'
  end
end
