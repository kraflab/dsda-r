require 'test_helper'

class DemosEditTest < ActionDispatch::IntegrationTest

  def setup
    @admin = admins(:elim)
    @demo = demos(:bt02speed)
    @player = @demo.players.first
    @wad = @demo.wad
    @category = @demo.category
  end

  test "must be logged in" do
    get edit_demo_path(@demo)
    assert_not flash.empty?
    assert_redirected_to root_url
    new_time = "10:10.10"
    patch demo_path(@demo), params: { demo:
                                      { guys: 1, tas: 1, level: "Map 01",
                                        time: new_time, version: 0,
                                        engine: "PRBoom+ v2.5.1.4",
                                        levelstat: "12:02.13",
                                        wad_username: @wad.username,
                                        category_name: @category.name,
                                        recorded_at: Time.zone.now },
                                      tags: ["blind"], shows: ["No", "Yes"],
                                      players: [@player.username] }
    assert_not_equal @demo.reload.time, new_time
    assert_not flash.empty?
    assert_redirected_to root_url
    assert_no_difference "Demo.count" do
      delete demo_path(@demo)
    end
    assert_not flash.empty?
    assert_redirected_to root_url
  end
end
