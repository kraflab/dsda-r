require 'test_helper'

class SessionSettingsTest < ActionDispatch::IntegrationTest
  
  def setup
    @iwad = iwads(:doom)
  end
  
  test "iwad settings" do
    get settings_path
    assert_match "Iwad Visibility", response.body
    iwad_key = "iwad:#{@iwad.id}"
    assert_nil cookies[iwad_key]
    patch settings_path, params: { iwad_key => "1" }
    assert_equal cookies[iwad_key], "1"
    patch settings_path, params: { iwad_key => "0" }
    assert_equal cookies[iwad_key], "0"
    assert_not flash.empty?
  end
end
