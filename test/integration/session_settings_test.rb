require 'test_helper'

class SessionSettingsTest < ActionDispatch::IntegrationTest
  
  def setup
  end
  
  test "settings" do
    get settings_path
    assert_response :success
    patch settings_path, params: { "cat:UV Speed" => "0", "hideTas" => "0" }
    assert_equal JSON.parse(cookies["category_filter"])["filter"], ["UV Speed"]
    assert_equal JSON.parse(cookies["category_filter"])["hideTas"], true
  end
end
