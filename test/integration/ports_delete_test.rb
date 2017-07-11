require 'test_helper'

class PortsDeleteTest < ActionDispatch::IntegrationTest

  def setup
    @admin = admins(:elim)
    @port  = ports(:prboom)
    @port.data = dummy_zip
    @port.save
  end

  test "must be logged in" do
    assert_no_difference "Port.count" do
      delete port_path(@port)
    end
    assert_not flash.empty?
    assert_redirected_to root_url
  end
end
