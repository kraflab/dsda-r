require 'test_helper'

class ApplicationControllerTest < ActionDispatch::IntegrationTest

  def setup
    @ac = ApplicationController.new
  end

  test "should return active elements" do
    assert_equal ([[wads(:btsx).id, 9], [wads(:recent_wad).id, 3], [wads(:record_wad).id, 3]]), @ac.active_wads(10)
    assert_equal ([[players(:kraflab).id, 13], [players(:kingdime).id, 2]]), @ac.active_players(10)
  end
end
