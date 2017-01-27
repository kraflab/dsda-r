require 'test_helper'

class AdminEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @admin = admins(:elim)
  end
  
  test "must be logged in" do
    get edit_path
    assert_redirected_to root_url
    assert_not flash.empty?
  end
  
  test "unsuccessful edit" do
    log_in_as(@admin)
    get edit_path
    assert_response :success
    patch edit_path, params: { admin:
                               { current_password:      "wrong",
                                 password:              "password1234",
                                 password_confirmation: "password1234" } }
    assert_select "label.control-label", "New password"
    assert_not flash.empty?
    patch edit_path, params: { admin:
                               { current_password:      "password1234",
                                 password:              "wrong",
                                 password_confirmation: "password1234" } }
    assert_select "label.control-label", "New password"
    assert flash.empty?
    patch edit_path, params: { admin:
                               { current_password:      "password1234",
                                 password:              "password1234",
                                 password_confirmation: "wrong" } }
    assert_select "label.control-label", "New password"
    assert flash.empty?
  end
  
  test "successful edit" do
    log_in_as(@admin)
    password = "password12341"
    patch edit_path, params: { admin:
                               { current_password:      "password1234",
                                 password:              password,
                                 password_confirmation: password } }
    assert_redirected_to root_url
    assert_not flash.empty?
    @admin.reload
    assert BCrypt::Password.new(@admin.password_digest).is_password?(password)
  end
end
