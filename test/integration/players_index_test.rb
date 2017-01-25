require 'test_helper'

class PlayersIndexTest < ActionDispatch::IntegrationTest
  
  test "index layout" do
    get players_path
    assert_select "div.panel-heading", "List of Players"
    players = Player.all
    players.each do |player|
      assert_select 'a[href=?]', player_path(player)
    end
  end
end
