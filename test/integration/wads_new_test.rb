require 'test_helper'

class WadsNewTest < ActionDispatch::IntegrationTest

  def setup
    @admin = admins(:elim)
  end

  test "must be logged in" do
    get new_wad_path
    assert_not flash.empty?
    assert_redirected_to root_url
    assert_no_difference "Wad.count" do
      post wads_path, params: { wad:
                                { name:   "Back to Saturn X 2",
                                  username: "btsx2", author: "Various",
                                  iwad_username: "doom2" } }
    end
    assert_not flash.empty?
    assert_redirected_to root_url
  end
end
