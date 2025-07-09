require 'test_helper'

class WadsCreateTest < ActionDispatch::IntegrationTest
  def setup
    @iwad = iwads(:doom2)
    @admin = admins(:elim)
    @params = {
      wad: {
        name: 'test_wad',
        short_name: 'test_wad',
        author: 'test_author',
        year: '2020',
        compatibility: 0,
        is_commercial: false,
        single_map: false,
        iwad: @iwad.name,
        parent: wads(:wad_1).short_name,
        file: {
          data: '1234',
          name: 'test_wad.zip'
        }
      }
    }
    @wrong_params = { wad: @params[:wad].merge(iwad: nil) }
    setup_auth_headers
  end

  test 'authenticated wad upload' do
    post '/api/wads/', params: @params, as: :json, headers: @headers
    created_wad = Wad.find_by(name: 'test_wad')
    assert created_wad.present?
    assert_equal created_wad.parent, wads(:wad_1)
    response_hash = JSON.parse(response.body)
    assert_equal response_hash['short_name'], created_wad.short_name
    assert_equal response_hash['name'], created_wad.name
    assert_equal response_hash['author'], created_wad.author
  end

  test 'invalid wad upload' do
    post '/api/wads/', params: @wrong_params, as: :json, headers: @headers
    assert_nil Wad.find_by(name: 'test_wad')
    assert_equal response.status, 422
    assert_includes response.body, '"iwad":["must exist"]'
  end

  test 'unauthenticated wad upload' do
    post '/api/wads/', params: @params, as: :json, headers: @wrong_headers
    assert_nil Wad.find_by(name: 'test_wad')
    assert_equal response.status, 401
    assert_includes response.body, 'Unauthorized'
  end
end
