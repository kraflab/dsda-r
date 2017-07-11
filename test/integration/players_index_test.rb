require 'test_helper'

class PlayersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @admin = admins(:elim)
  end

  test "index layout" do
    get players_path
    assert_select "h1", "Player List"
    players = Player.all
    players.each do |player|
      assert_select 'a[href=?]', player_path(player)
      assert_select 'td', player.demos.count.to_s
      assert_select 'td', total_demo_time(player)
    end
    assert_select 'a[href=?]', new_player_path, count: 0
  end
end
