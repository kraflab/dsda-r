require 'test_helper'

class SessionSettingsTest < ActionDispatch::IntegrationTest
  
  def setup
  end
  
  test "iwad settings" do
    get settings_path
    assert_response :success
  end
end
