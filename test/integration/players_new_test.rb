require 'test_helper'

class PlayersNewTest < ActionDispatch::IntegrationTest
  
  def setup
    @admin = admins(:elim)
  end
  
  test "must be logged in" do
    get new_player_path
    assert_not flash.empty?
    assert_redirected_to root_url
    assert_no_difference "Player.count" do
      post players_path, params: { player:
                                   { name: "Good",   username: "",
                                     twitch: "", youtube: "" } }
    end
    assert_not flash.empty?
    assert_redirected_to root_url
  end
  
  test "unsuccessful creation" do
    log_in_as(@admin)
    get new_player_path
    assert_response :success
    assert_select "input.btn[value=?]", "Create Player"
    assert_no_difference "Player.count" do
      post players_path, params: { player:
                                   { name: "",   username: "",
                                     twitch: "", youtube: "" } }
    end
    assert_select "input.btn[value=?]", "Create Player"
    assert_no_difference "Player.count" do
      post players_path, params: { player:
                                   { name: "Good", username: "bad$",
                                     twitch: "",   youtube: "" } }
    end
    assert_select "input.btn[value=?]", "Create Player"
  end
  
  test "successful creation" do
    log_in_as(@admin)
    assert_difference "Player.count" do
      post players_path, params: { player:
                                   { name: "Good", username: "",
                                     twitch: "",   youtube: "" } }
    end
    assert_not flash.empty?
    assert_redirected_to player_path("good")
    assert_difference "Player.count" do
      post players_path, params: { player:
                                   { name: "$God-N4me", username: "good_",
                                     twitch: "good123",   youtube: "good321" } }
    end
    assert_not flash.empty?
    assert_redirected_to player_path("good_")
  end
end
