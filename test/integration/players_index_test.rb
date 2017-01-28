require 'test_helper'

class PlayersIndexTest < ActionDispatch::IntegrationTest
  
  def setup
    @admin = admins(:elim)
  end
  
  test "index layout" do
    get players_path
    assert_select "div.panel-heading", "List of Players"
    players = Player.all
    players.each do |player|
      assert_select 'a[href=?]', player_path(player)
    end
    assert_select 'a[href=?]', new_player_path, 0
    log_in_as(@admin)
    get players_path
    assert_select 'a[href=?]', new_player_path
  end
end
