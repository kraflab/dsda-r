require 'test_helper'

class DemosCreateTest < ActionDispatch::IntegrationTest
  def setup
    @wad = wads(:btsx)
    @admin = admins(:elim)
    @params = {
      demo: {
        time: '1:11.13',
        tas: false,
        guys: 1,
        level: 'E1M1',
        recorded_at: '2018-03-15 23:08:46 +0100',
        levelstat: '',
        engine: 'ZDoom v2.7',
        secret_exit: false,
        version: 0,
        video_link: 'xyz',
        wad: @wad.short_name,
        category: 'UV Speed',
        players: [players(:kraflab).name],
        tags: [{ text: 'Also reality', show: 1 }],
        file: {
          data: '1234',
          name: 'test_demo.zip'
        }
      }
    }
    @wrong_params = { demo: @params[:demo].merge(wad: nil) }
    setup_auth_headers
  end

  test 'authenticated demo upload' do
    post '/api/demos/', params: @params, as: :json, headers: @headers
    created_demo = Demo.find_by(tics: 7113)
    assert created_demo.present?
    response_hash = JSON.parse(response.body)
    assert_equal response_hash['players'], created_demo.players.map(&:name)
    assert_equal response_hash['time'], created_demo.time
    assert_equal response_hash['category'], created_demo.category_name
  end

  test 'invalid demo upload' do
    post '/api/demos/', params: @wrong_params, as: :json, headers: @headers
    assert_nil Demo.find_by(tics: 7113)
    assert_equal response.status, 422
    assert_includes response.body, '"wad":["must exist'
  end

  test 'unauthenticated demo upload' do
    post '/api/demos/', params: @params, as: :json, headers: @wrong_headers
    assert_nil Demo.find_by(tics: 7113)
    assert_equal response.status, 401
    assert_includes response.body, 'Unauthorized'
  end
end
