require 'test_helper'

class PlayersControllerTest < ActionDispatch::IntegrationTest
  
  test "should get new" do
    get new_player_path
    assert_response :success
  end
  
  test "should get index" do
    get players_path
    assert_response :success
  end
end
