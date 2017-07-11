require 'test_helper'

class PortsNewTest < ActionDispatch::IntegrationTest

  def setup
    @admin = admins(:elim)
  end

  test "must be logged in" do
    get new_port_path
    assert_not flash.empty?
    assert_redirected_to root_url
    assert_no_difference "Port.count" do
      post ports_path, params: { port:
                                   { family: "GZDoom", version: "v2.0.05" } }
    end
    assert_not flash.empty?
    assert_redirected_to root_url
  end
end
