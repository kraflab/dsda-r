require 'test_helper'

class PortsDeleteTest < ActionDispatch::IntegrationTest
  
  def setup
    @admin = admins(:elim)
    @port  = ports(:prboom)
  end
  
  test "must be logged in" do
    assert_no_difference "Port.count" do
      delete port_path(@port)
    end
    assert_not flash.empty?
    assert_redirected_to root_url
  end
  
  test "unsuccessful delete" do
    log_in_as(@admin)
    @port.created_at = 2.days.ago
    @port.save
    assert_no_difference "Port.count" do
      delete port_path(@port)
    end
    assert_not flash.empty?
    assert_redirected_to root_url
  end
  
  test "successful delete" do
    log_in_as(@admin)
    assert_difference "Port.count", -1 do
      delete port_path(@port)
    end
    assert_not flash.empty?
    assert_redirected_to ports_path
  end
end
