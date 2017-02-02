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
    assert_select "a[href=?]", edit_wad_path(@wad), 0
    log_in_as(@admin)
    get wad_path(@wad)
    assert_select "a[href=?]", edit_wad_path(@wad)
  end
end
