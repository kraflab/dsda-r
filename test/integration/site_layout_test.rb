require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  
  test "home page content and links" do
    get root_path
    assert_select "title", "Home | DSDA"
    assert_select "div.panel"
    assert_select "div.panel-heading", "Demo Categories & Types"
    assert_select "td", "Exit as fast as possible on skill 4."
    assert_select "a[href=?]", players_url
    assert_select "a[href=?]", iwads_url
    assert_select "a[href=?]", wads_url
    assert_select "a[href=?]", "https://www.doomworld.com/vb/doom-speed-demos/"
  end
end
