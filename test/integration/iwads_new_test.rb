require 'test_helper'

class IwadsNewTest < ActionDispatch::IntegrationTest
  
  def setup
    @admin = admins(:elim)
  end
  
  test "must be logged in" do
    get new_iwad_path
    assert_not flash.empty?
    assert_redirected_to root_url
    assert_no_difference "Iwad.count" do
      post iwads_path, params: { iwad:
                                   { name:   "Chex Quest", username: "chex",
                                     author: "Digital Café" } }
    end
    assert_not flash.empty?
    assert_redirected_to root_url
  end
  
  test "unsuccessful creation" do
    log_in_as(@admin)
    get new_iwad_path
    assert_response :success
    assert_select "input.btn[value=?]", "Create Iwad"
    assert_no_difference "Iwad.count" do
      post iwads_path, params: { iwad:
                                   { name:   "", username: "",
                                     author: "" } }
    end
    assert_select "input.btn[value=?]", "Create Iwad"
  end
  
  test "successful creation" do
    log_in_as(@admin)
    assert_difference "Iwad.count" do
      post iwads_path, params: { iwad:
                                   { name:   "Chex Quest", username: "chex",
                                     author: "Digital Café" } }
    end
    assert_not flash.empty?
    assert_redirected_to iwad_path("chex")
  end
end
