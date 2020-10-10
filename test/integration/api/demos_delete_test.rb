require 'test_helper'

class DemosDeleteTest < ActionDispatch::IntegrationTest
  def setup
    @demo = demos(:bt01speed)
    @admin = admins(:elim)
    @unauthorized_admin = admins(:bob)
    @params = {
      demo_delete: {
        match_details: {
          level: @demo.level,
          wad: @demo.wad.name,
          category: @demo.category_name,
          time: '9.99'
        }
      }
    }
    setup_auth_headers(with_otp: true)
  end

  test 'authenticated demo delete' do
    delete '/api/demos/', params: @params, as: :json, headers: @headers
    assert_nil Demo.find_by(id: @demo.id)
    assert_equal response.status, 200
    assert JSON.parse(response.body)['success']
  end

  test 'imprecise details demo delete' do
    @params[:demo_delete][:match_details].delete(:time)
    delete '/api/demos/', params: @params, as: :json, headers: @headers
    assert Demo.find_by(id: @demo.id)
    assert_equal response.status, 422
    assert_includes response.body, 'Multiple matches'
  end

  test 'inaccurate details demo delete' do
    @params[:demo_delete][:match_details] = {}
    delete '/api/demos/', params: @params, as: :json, headers: @headers
    assert Demo.find_by(id: @demo.id)
    assert_equal response.status, 404
  end

  test 'unauthenticated demo delete' do
    delete '/api/demos/', params: @params, as: :json, headers: @wrong_headers
    assert Demo.find_by(id: @demo.id)
    assert_equal response.status, 401
    assert_includes response.body, 'Unauthorized'
  end

  test 'unauthorized demo delete' do
    delete '/api/demos/', params: @params, as: :json, headers: @unauthorized_headers
    assert Demo.find_by(id: @demo.id)
    assert_equal response.status, 401
    assert_includes response.body, 'Unauthorized'
  end

  test 'wrong otp' do
    @headers['OTP'] = '000000'
    delete '/api/demos/', params: @params, as: :json, headers: @headers
    assert Demo.find_by(id: @demo.id)
    assert_equal response.status, 401
    assert_includes response.body, 'Unauthorized'
  end
end
