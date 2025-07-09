require 'test_helper'

class WadsGetTest < ActionDispatch::IntegrationTest
  def setup
    @wad = wads(:btsx)
  end

  test 'get wad' do
    get "/api/wads/#{@wad.short_name}", as: :json
    response_hash = JSON.parse(response.body)
    assert_equal response_hash['short_name'], @wad.short_name
    assert_equal response_hash['name'], @wad.name
    assert_equal response_hash['author'], @wad.author
  end

  test 'missing wad' do
    get "/api/wads/fakewad", as: :json
    response_hash = JSON.parse(response.body)
    assert_equal response_hash['error'], 'not found'
  end
end
