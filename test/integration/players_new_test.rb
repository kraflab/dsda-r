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
end
