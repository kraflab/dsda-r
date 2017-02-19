require 'test_helper'

class WadsShowTest < ActionDispatch::IntegrationTest
  
  def setup
    @admin = admins(:elim)
    @wad   = wads(:btsx)
  end
  
  test "layout and buttons" do
    get wad_path(@wad)
    assert_response :success
    assert_select "h1 > small"
    assert_match @wad.name, response.body
    demo = @wad.demos.first
    assert_select "td", demo.level
    assert_select "td", demo.category.name
    assert_select "td", demo.port_text
    assert_select "td", demo.time
    assert_select "td", demo.note
    demo.players.each do |pl|
      assert_match pl.name, response.body
    end
    assert_select "a[href=?]", edit_wad_path(@wad), 0
    log_in_as(@admin)
    get wad_path(@wad)
    assert_select "a[href=?]", edit_wad_path(@wad)
  end
end
