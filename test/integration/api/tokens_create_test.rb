require 'test_helper'

class TokensCreateTest < ActionDispatch::IntegrationTest
  def setup
    @admin = admins(:elim)
    @params = {
      password: 'password1234',
      username: @admin.username
    }
    @wrong_params = {
      password: 'passwordxxxx',
      username: @admin.username
    }
  end

  test 'authenticated token request' do
    post '/api/tokens/', params: @params, as: :json
    assert_equal response.status, 201
    response_hash = JSON.parse(response.body)
    assert Time.at(response_hash['exp']).future?
    token = JsonWebToken.decode(response_hash['token'])
    assert_equal token[:sub].to_i, @admin.id
  end

  test 'unauthenticated token request' do
    post '/api/tokens/', params: @wrong_params, as: :json
    assert_equal response.status, 401
    assert_includes response.body, 'Unauthorized'
  end
end
