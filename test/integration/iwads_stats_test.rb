require 'test_helper'

class IwadsStatsTestTest < ActionDispatch::IntegrationTest

  def setup
    @iwad = iwads(:doom2)
  end

  test "stats page" do
    get iwad_stats_path(@iwad)
    assert_select "title", "#{@iwad.name} | Stats | DSDA"
    assert_select "div.page-header", "#{@iwad.name} Stats & Charts"
    assert_select "div.chart-style[id=?]", "demo_count_by_month"
  end
end
