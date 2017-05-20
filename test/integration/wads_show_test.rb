require 'test_helper'

class WadsShowTest < ActionDispatch::IntegrationTest

  def setup
    @admin = admins(:elim)
    @wad   = wads(:btsx)
    @pacifist = demos(:bt01pacifist)
  end

  test "layout and buttons" do
    get wad_path(@wad)
    assert_response :success
    assert_select "h1 > small"
    assert_match @wad.name, response.body
    assert_select "a[href=?]", wad_stats_path(@wad)
    demo = @wad.demos.first
    assert_select "td", demo.level
    assert_select "td", demo.category.name
    assert_select "td", demo.engine
    assert_select "td", demo.time
    assert_select "td", demo.note.strip
    demo.players.each do |pl|
      assert_match pl.name, response.body
    end
    assert_select "td", @pacifist.time, count: 2
    assert_select "a[href=?]", edit_wad_path(@wad), count: 0
    cookies["category_filter"] = '{"filter": ["UV Speed"]}'
    log_in_as(@admin)
    get wad_path(@wad)
    assert_select "td", demo.category.name, count: 0
    assert_select "a[href=?]", edit_wad_path(@wad)
    assert_select "a[href=?]", new_demo_path + "?wad=" + @wad.username
  end
end
