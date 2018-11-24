require 'test_helper'

class PlayersStatsTest < ActionDispatch::IntegrationTest

  def setup
    @player = players(:kraflab)
  end

  test "stats page" do
    get player_stats_path(@player)
    assert_select "title", "#{@player.name} | Stats | DSDA"
    assert_select "div.page-header", "#{@player.name} Stats & Charts"
    assert_select "div.chart-style[id=?]", "demo_count_by_year"
  end
end
