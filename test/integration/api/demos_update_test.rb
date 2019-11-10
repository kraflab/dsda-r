require 'test_helper'

class DemosUpdateTest < ActionDispatch::IntegrationTest
  def setup
    @demo = demos(:bt01speed)
    @wad = wads(:wad_10)
    @admin = admins(:elim)
    @params = {
      demo_update: {
        time: '1:11.13',
        wad: @wad.short_name,
        category: 'Pacifist',
        players: ['elim'],
        match_details: {
          level: @demo.level,
          wad: @demo.wad.name,
          category: @demo.category_name,
          time: '9.99'
        },
        tags: [
          { text: 'Ballerina', show: true }
        ]
      }
    }
    @wrong_params = { demo_update: @params[:demo_update].merge(wad: 'foo') }
    @headers = {
      'HTTP_API_USERNAME' => @admin.username,
      'HTTP_API_PASSWORD' => 'password1234'
    }
    @wrong_headers = {
      'HTTP_API_USERNAME' => @admin.username,
      'HTTP_API_PASSWORD' => 'password5678'
    }
  end

  test 'authenticated demo update' do
    patch '/api/demos/', params: @params, as: :json, headers: @headers
    @demo.reload
    assert_equal @demo.time, '1:11.13'
    assert_equal @demo.wad_id, @wad.id
    assert_equal @demo.category_name, 'Pacifist'
    assert_equal @demo.players.first.name, 'elim'
    assert_equal @demo.sub_categories.map(&:name), ['Ballerina']
    response_hash = JSON.parse(response.body)
    assert response_hash['save']
    assert_equal response_hash['demo']['id'], @demo.id
    assert_equal response_hash['demo']['file_id'], @demo.demo_file.id
  end

  test 'imprecise details demo update' do
    @params[:demo_update][:match_details].delete(:time)
    patch '/api/demos/', params: @params, as: :json, headers: @headers
    assert_equal @demo.time, @demo.reload.time
    assert_equal response.status, 422
    assert_includes response.body, 'Multiple matches'
  end

  test 'inaccurate details demo update' do
    @params[:demo_update][:match_details] = {}
    patch '/api/demos/', params: @params, as: :json, headers: @headers
    assert_equal @demo.time, @demo.reload.time
    assert_equal response.status, 404
  end

  test 'invalid demo update' do
    patch '/api/demos/', params: @wrong_params, as: :json, headers: @headers
    assert_equal @demo.time, @demo.reload.time
    assert_equal response.status, 422
    assert_includes response.body, '"wad":["must exist'
  end

  test 'unauthenticated demo update' do
    patch '/api/demos/', params: @params, as: :json, headers: @wrong_headers
    assert_equal @demo.time, @demo.reload.time
    assert_equal response.status, 401
    assert_includes response.body, 'Unauthorized'
  end
end
