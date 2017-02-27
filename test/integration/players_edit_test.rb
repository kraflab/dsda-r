require 'test_helper'

class PlayersEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @admin  = admins(:elim)
    @player = players(:kraflab)
  end
  
  test "must be logged in" do
    get edit_player_path(@player)
    assert_not flash.empty?
    assert_redirected_to root_url
    new_name = "Good"
    patch player_path(@player), params: { player:
                                          { name: new_name, 
                                            old_username: @player.username, 
                                            username: "",
                                            twitch: "", youtube: "" } }
    assert_not_equal @player.reload.name, new_name
    assert_not flash.empty?
    assert_redirected_to root_url
    assert_no_difference "Player.count" do
      delete player_path(@player)
    end
    assert_not flash.empty?
    assert_redirected_to root_url
  end
  
  test "unsuccessful edit" do
    log_in_as(@admin)
    get edit_player_path(@player)
    assert_response :success
    assert_select "input.btn[value=?]", "Update"
    new_name = "Good"
    patch player_path(@player), params: { player:
                                          { name: new_name, 
                                            old_username: @player.username, 
                                            username: "",
                                            twitch: "bad link", youtube: "" } }
    assert_select "input.btn[value=?]", "Update"
    assert_not_equal @player.reload.name, new_name
  end
  
  test "unsuccessful delete" do
    log_in_as(@admin)
    @player.created_at = 2.days.ago
    @player.save
    assert_no_difference "Player.count" do
      delete player_path(@player)
    end
    assert_not flash.empty?
    assert_redirected_to root_url
  end
  
  test "successful edit and delete" do
    log_in_as(@admin)
    new_name     = "Good Name"
    new_username = "good_13"
    new_twitch   = "yoyoyo"
    new_youtube  = "hey14"
    patch player_path(@player), params: { player:
                                          { name: new_name, 
                                            old_username: @player.username, 
                                            username: new_username,
                                            twitch: new_twitch,
                                            youtube: new_youtube } }
    assert_not flash.empty?
    @player = @player.reload
    assert_redirected_to player_path(@player)
    assert_equal @player.name,     new_name
    assert_equal @player.username, new_username
    assert_equal @player.twitch,   new_twitch
    assert_equal @player.youtube,  new_youtube
    assert_difference "Player.count", -1 do
      delete player_path(@player)
    end
    assert_not flash.empty?
    assert_redirected_to players_path
  end
end
