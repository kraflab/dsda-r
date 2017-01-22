require 'test_helper'

class PlayersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get players_new_url
    assert_response :success
  end

end
