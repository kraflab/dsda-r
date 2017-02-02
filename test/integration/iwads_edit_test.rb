require 'test_helper'

class IwadsEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @admin  = admins(:elim)
    @iwad = iwads(:doom)
  end
  
  test "must be logged in" do
    get edit_iwad_path(@iwad)
    assert_not flash.empty?
    assert_redirected_to root_url
    new_name = "Good"
    patch iwad_path(@iwad), params: { iwad:
                                          { name: new_name, 
                                            old_username: @iwad.username, 
                                            username: "", author: "" } }
    assert_not_equal @iwad.reload.name, new_name
    assert_not flash.empty?
    assert_redirected_to root_url
    assert_no_difference "Iwad.count" do
      delete iwad_path(@iwad)
    end
    assert_not flash.empty?
    assert_redirected_to root_url
  end
  
  test "unsuccessful edit" do
    log_in_as(@admin)
    get edit_iwad_path(@iwad)
    assert_response :success
    assert_select "input.btn[value=?]", "Edit Iwad"
    new_name = "Good"
    patch iwad_path(@iwad), params: { iwad:
                                          { name: new_name, 
                                            old_username: @iwad.username, 
                                            username: " $$doom",
                                            author: "" } }
    assert_select "input.btn[value=?]", "Edit Iwad"
    assert_not_equal @iwad.reload.name, new_name
    patch iwad_path(@iwad), params: { iwad:
                                          { name: new_name, 
                                            old_username: @iwad.username, 
                                            username: "chexquest",
                                            author: " " } }
    assert_select "input.btn[value=?]", "Edit Iwad"
    assert_not_equal @iwad.reload.name, new_name
  end
  
  test "successful edit and delete" do
    log_in_as(@admin)
    new_name     = "Good Name"
    new_username = "good_13"
    new_author   = "Dr Jekyll 2017"
    patch iwad_path(@iwad), params: { iwad:
                                          { name: new_name, 
                                            old_username: @iwad.username, 
                                            username: new_username,
                                            author: new_author } }
    assert_not flash.empty?
    @iwad = @iwad.reload
    assert_redirected_to iwad_path(@iwad)
    assert_equal @iwad.name,     new_name
    assert_equal @iwad.username, new_username
    assert_equal @iwad.author,   new_author
    assert_difference "Iwad.count", -1 do
      delete iwad_path(@iwad)
    end
    assert_not flash.empty?
    assert_redirected_to iwads_path
  end
end
