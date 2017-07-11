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
end
