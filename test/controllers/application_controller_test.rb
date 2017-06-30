require 'test_helper'

class ApplicationControllerTest < ActionDispatch::IntegrationTest

  def setup
    @ac = ApplicationController.new
  end

  test "should return active elements" do
    assert_equal ({wads(:btsx).id => 7, wads(:recent_wad).id => 3}), @ac.active_wads(10)
    assert_equal ({players(:kingdime).id => 2, players(:kraflab).id => 1}), @ac.active_players(3)
  end
end
