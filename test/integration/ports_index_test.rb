require 'test_helper'

class PortsIndexTest < ActionDispatch::IntegrationTest
  
  def setup
    @admin = admins(:elim)
  end
  
  test "index layout" do
    get ports_path
    assert_select "h1", "Port List"
    ports = Port.all
    ports.each do |port|
      assert_match port.family, response.body
      assert_match port.version, response.body
      assert_select 'a[href=?]', edit_port_path(port), 0
    end
    assert_select 'a[href=?]', new_port_path, 0
    log_in_as(@admin)
    get ports_path
    assert_select 'a[href=?]', new_port_path
  end
end
