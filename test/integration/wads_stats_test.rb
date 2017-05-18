require 'test_helper'

class WadsStatsTest < ActionDispatch::IntegrationTest

  def setup
    @wad = wads(:btsx)
  end

  test "stats page" do
    get wad_stats_path(@wad)
    assert_select "title", "#{@wad.name} | Stats | DSDA"
    assert_select "div.page-header", "#{@wad.name} Stats & Charts"
    assert_select "div.chart-style[id=?]", "demo_count_by_month"
  end
end
