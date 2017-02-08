require 'test_helper'

class PortsEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @admin = admins(:elim)
    @port  = ports(:prboom)
  end
  
  test "must be logged in" do
    get edit_port_path(@port)
    assert_not flash.empty?
    assert_redirected_to root_url
    new_family = "GZDoom"
    patch port_path(@port), params: { port:
                                      { family:  new_family,
                                        version: @port.version } }
    assert_not_equal @port.reload.family, new_family
    assert_not flash.empty?
    assert_redirected_to root_url
    assert_no_difference "Port.count" do
      delete port_path(@port)
    end
    assert_not flash.empty?
    assert_redirected_to root_url
  end
  
  test "unsuccessful edit" do
    log_in_as(@admin)
    get edit_port_path(@port)
    assert_response :success
    assert_select "input.btn[value=?]", "Edit Port"
    new_family = "GZDoom"
    patch port_path(@port), params: { port:
                                      { family:  new_family, old_id: @port.id,
                                        version: "v Bad" } }
    assert_select "input.btn[value=?]", "Edit Port"
    assert_not_equal @port.reload.family, new_family
    new_version = "v2.5.1.1"
    patch port_path(@port), params: { port:
                                      { family:  "$NDoom", old_id: @port.id,
                                        version: new_version } }
    assert_select "input.btn[value=?]", "Edit Port"
    assert_not_equal @port.reload.version, new_version
  end
  
  test "successful edit and delete" do
    log_in_as(@admin)
    new_family  = "GZDoom"
    new_version = "v2.5.1.1"
    patch port_path(@port), params: { port:
                                      { family:  new_family, old_id: @port.id,
                                        version: new_version } }
    assert_not flash.empty?
    @port = @port.reload
    assert_redirected_to ports_path
    assert_equal @port.family,  new_family
    assert_equal @port.version, new_version
    assert_difference "Port.count", -1 do
      delete port_path(@port)
    end
    assert_not flash.empty?
    assert_redirected_to ports_path
  end
end
