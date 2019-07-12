require 'test_helper'

class SessionSettingsTest < ActionDispatch::IntegrationTest

  def setup
  end

  test "settings" do
    skip('Temporarily disabled')
    get settings_path
    assert_response :success
    patch settings_path, params: { "cat:UV Speed" => "0", "tas" => "0" }
    assert_equal JSON.parse(cookies['demo_filter'])['category'], ["UV Speed"]
    assert_equal JSON.parse(cookies['demo_filter'])['tas'], true
  end
end
