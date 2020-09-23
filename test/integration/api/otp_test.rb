require 'test_helper'

class OtpTest < ActionDispatch::IntegrationTest
  def setup
    @admin = admins(:elim)
    setup_auth_headers
  end

  test 'authenticated request' do
    post '/api/otp/', params: {}, as: :json, headers: @headers
    assert @admin.reload.otp.present?
    response_hash = JSON.parse(response.body)
    assert response_hash['otp']
  end

  test 'repeat request' do
    OtpHandler.reset_otp!(@admin)
    old_otp = @admin.otp
    post '/api/otp/', params: {}, as: :json, headers: @headers
    assert_equal response.status, 422
    assert_equal old_otp, @admin.reload.otp
    assert_includes response.body, 'You can only set an otp once.'
  end

  test 'unauthenticated request' do
    post '/api/otp/', params: {}, as: :json, headers: @wrong_headers
    assert_nil @admin.otp
    assert_equal response.status, 401
    assert_includes response.body, 'Unauthorized'
  end
end
