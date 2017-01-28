require 'test_helper'

class AdminLoginTest < ActionDispatch::IntegrationTest
  
  def setup
    @admin = admins(:elim)
  end
  
  test "login with invalid information" do
    get login_path
    assert_response :success
    assert_select "label.control-label", "Password"
    post login_path, params: { session: { username: "", password: "" } }
    assert_not is_logged_in?
    assert_not flash.empty?
    post login_path, params: { session: { username: @admin.username,
                                          password: "other" } }
    assert_not is_logged_in?
    assert_not flash.empty?
    post login_path, params: { session: { username: "other",
                                          password: "password1234" } }
    assert_not is_logged_in?
    assert_not flash.empty?
  end
  
  test "login with valid information followed by logout" do
    get login_path
    post login_path, params: { session: { username: @admin.username,
                                          password: 'password1234' } }
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to root_url
    follow_redirect!
    assert_select "a[href=?]", logout_path
    delete logout_path
    assert_not is_logged_in?
    assert_not flash.empty?
    assert_redirected_to root_url
    assert_select "a[href=?]", logout_path, count: 0
  end
end
