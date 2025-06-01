require 'test_helper'

class PortsIndexTest < ActionDispatch::IntegrationTest

  def setup
    @admin = admins(:elim)
  end

  test "index layout" do
    get ports_path
    assert_select "h3", "Archived"
    ports = Port.all
    ports.each do |port|
      assert_match port.family, response.body
      assert_match port.version, response.body
    end
  end
end
