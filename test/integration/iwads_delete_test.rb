require 'test_helper'

class IwadsDeleteTest < ActionDispatch::IntegrationTest
  
  def setup
    @admin  = admins(:elim)
    @iwad = iwads(:doom)
  end
  
  test "must be logged in" do
    assert_no_difference "Iwad.count" do
      delete iwad_path(@iwad)
    end
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "successful delete" do
    log_in_as(@admin)
    assert_difference "Iwad.count", -1 do
      delete iwad_path(@iwad)
    end
    assert_not flash.empty?
    assert_redirected_to iwads_path
  end
end
