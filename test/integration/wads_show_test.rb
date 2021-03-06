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
    assert_match demos(:bt01pacifist).video_link, response.body
  end

  test "level selection" do
    get wad_path(@wad, level: "Map 01")
    assert_select 'td', { count: 0, text: 'Map 02' }, 'maps not filtered by params'
    get wad_path(@wad, level: "Episode 2 ILs")
    assert_select 'td', { count: 0, text: 'Map 01' }
    assert_select 'td', 'Map 11'
  end
end
