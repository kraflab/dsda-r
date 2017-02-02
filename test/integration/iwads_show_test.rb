require 'test_helper'

class IwadsShowTest < ActionDispatch::IntegrationTest
  
  def setup
    @admin = admins(:elim)
    @iwad  = iwads(:doom)
  end
  
  test "layout and buttons" do
    get iwad_path(@iwad)
    assert_response :success
    assert_select "h1 > small"
    assert_match @iwad.name, response.body
    @iwad.wads.each do |wad|
      assert_select "a[href=?]", wad_path(wad)
    end
    assert_select "a[href=?]", edit_iwad_path(@iwad), 0
    log_in_as(@admin)
    get iwad_path(@iwad)
    assert_select "a[href=?]", edit_iwad_path(@iwad)
    assert_select "a[href=?]", new_wad_path + "?iwad_username=" + @iwad.username
  end
end
