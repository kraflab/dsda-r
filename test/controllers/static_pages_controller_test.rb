require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  
  test "should get home" do
    get "/home"
    assert_response :success
    assert_select "title", "Home | DSDA"
    assert_select "div.panel"
    assert_select "div.panel-heading", "Demo Categories & Types"
    assert_select "td", "Exit as fast as possible on skill 4."
  end

end
