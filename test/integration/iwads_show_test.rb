require 'test_helper'

class IwadsShowTest < ActionDispatch::IntegrationTest
  
  def setup
    @admin = admins(:elim)
    @iwad = iwads(:doom)
  end
  
  test "layout and buttons" do
    get iwad_path(@iwad)
    assert_response :success
    assert_select "h1 > small"
    assert_match @iwad.name, response.body
    assert_select "a[href=?]", edit_iwad_path(@iwad), 0
    log_in_as(@admin)
    get iwad_path(@iwad)
    assert_select "a[href=?]", edit_iwad_path(@iwad)
  end
end
