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
end
