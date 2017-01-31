require 'test_helper'

class PlayersShowTest < ActionDispatch::IntegrationTest
  
  def setup
    @admin = admins(:elim)
    @player = players(:kingdime)
    @player_links = players(:kraflab)
  end
  
  test "layout and buttons" do
    get player_path(@player_links)
    assert_response :success
    assert_select "a[href=?]", @player_links.twitch_url
    assert_select "a[href=?]", @player_links.youtube_url
    get player_path(@player)
    assert_response :success
    assert_select "div > a", count: 0, text: "Twitch"
    assert_select "div > a", count: 0, text: "YouTube"
    assert_select "h1 > small"
    assert_match @player.name, response.body
    assert_select "a[href=?]", edit_player_path(@player), 0
    assert_select "a[data-method=delete][href=?]", player_path(@player), 0
    log_in_as(@admin)
    get player_path(@player)
    assert_select "a[href=?]", edit_player_path(@player)
    assert_select "a[data-method=delete][href=?]", player_path(@player)
  end
end