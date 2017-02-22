require 'test_helper'

class IwadsShowTest < ActionDispatch::IntegrationTest
  
  def setup
    @admin = admins(:elim)
    @iwad  = iwads(:doom2)
  end
  
  test "layout and buttons" do
    get iwad_path(@iwad)
    assert_response :success
    assert_select "h1 > small"
    assert_match @iwad.name, response.body
    @iwad.wads.each do |wad|
      assert_select "a[href=?]", wad_path(wad)
      assert_select "td", wad.name
      assert_select "td", wad.author
      assert_select "td", wad.demos.count.to_s
      assert_select "td", total_demo_time(wad, false)
    end
    log_in_as(@admin)
    get iwad_path(@iwad)
    assert_select "a[href=?]", new_wad_path + "?iwad=" + @iwad.username
  end
end
