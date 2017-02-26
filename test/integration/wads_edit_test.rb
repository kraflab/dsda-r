require 'test_helper'

class WadsEditTest < ActionDispatch::IntegrationTest
 
  def setup
    @admin  = admins(:elim)
    @wad    = wads(:btsx)
  end
  
  test "must be logged in" do
    get edit_wad_path(@wad)
    assert_not flash.empty?
    assert_redirected_to root_url
    new_name = "Good"
    patch wad_path(@wad), params: { wad:
                                    { name: new_name, username: "btsx",
                                      author: "Various",
                                      old_username: @wad.username,
                                      iwad_username: "doom2" } }
    assert_not_equal @wad.reload.name, new_name
    assert_not flash.empty?
    assert_redirected_to root_url
    assert_no_difference "Wad.count" do
      delete wad_path(@wad)
    end
    assert_not flash.empty?
    assert_redirected_to root_url
  end
  
  test "unsuccessful edit" do
    log_in_as(@admin)
    get edit_wad_path(@wad)
    assert_response :success
    assert_select "input.btn[value=?]", "Edit Wad"
    new_name = "Good"
    patch wad_path(@wad), params: { wad:
                                    { name: new_name, username: "btsx$$",
                                      author: "Various",
                                      old_username: @wad.username,
                                      iwad_username: "doom2" } }
    assert_select "input.btn[value=?]", "Edit Wad"
    assert_not_equal @wad.reload.name, new_name
  end
  
  test "successful edit and delete" do
    log_in_as(@admin)
    new_name     = "Good Name"
    new_username = "good_13"
    new_author   = "Dr Jekyll 2017"
    new_iwad     = "doom"
    patch wad_path(@wad), params: { wad:
                                    { name: new_name, username: new_username,
                                      author: new_author,
                                      old_username: @wad.username,
                                      iwad_username: new_iwad } }
    assert_not flash.empty?
    @wad = @wad.reload
    assert_redirected_to wad_path(@wad)
    assert_equal @wad.name,          new_name
    assert_equal @wad.username,      new_username
    assert_equal @wad.author,        new_author
    assert_equal @wad.iwad.username, new_iwad
    assert_difference "Wad.count", -1 do
      delete wad_path(@wad)
    end
    assert_not flash.empty?
    assert_redirected_to wads_path
  end
end
