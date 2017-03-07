require 'test_helper'

class DemosNewTest < ActionDispatch::IntegrationTest
  
  def setup
    @admin = admins(:elim)
    @player = players(:kraflab)
    @player_2 = players(:kingdime)
    @wad = wads(:btsx)
    @category = categories(:uvspeed)
  end
  
  test "must be logged in" do
    get new_demo_path
    assert_not flash.empty?
    assert_redirected_to root_url
    assert_no_difference "Demo.count" do
      post demos_path, params: { demo:
                                 { guys: 1, tas: 1, level: "Map 01",
                                   time: "12:02.13", version: 0,
                                   engine: "PRBoom+ v2.5.1.4",
                                   levelstat: "12:02.13",
                                   wad_username: @wad.username,
                                   category_name: @category.name,
                                   recorded_at: Time.zone.now, file: "" },
                                 tags: ["blind"], shows: ["No", "Yes"],
                                 players: [@player.username] }
    end
    assert_not flash.empty?
    assert_redirected_to root_url
  end
  
  test "unsuccessful creation" do
    log_in_as(@admin)
    get new_demo_path
    assert_response :success
    assert_select "input.btn[value=?]", "Create"
    assert_no_difference "Demo.count" do
      post demos_path, params: { demo:
                                 { guys: 1, tas: 1, level: "",
                                   time: "",
                                   engine: "", version: 0,
                                   levelstat: "",
                                   wad_username: "",
                                   category_name: "",
                                   recorded_at: Time.zone.now, file: "" },
                                 tags: [""], shows: [""],
                                 players: [@player.username] }
    end
    assert_select "input.btn[value=?]", "Create"
  end
  
  test "successful creation" do
    log_in_as(@admin)
    assert_difference "Demo.count" do
      post demos_path, params: { demo:
                                 { guys: 1, tas: 1, level: "Map 01",
                                   time: "12:02.13", version: 0,
                                   engine: "PRBoom+ v2.5.1.4",
                                   levelstat: "12:02.13",
                                   wad_username: @wad.username,
                                   category_name: @category.name,
                                   recorded_at: Time.zone.now, file: "" },
                                 tags: ["blind"], shows: ["No", "Yes"],
                                 players: [@player.username, @player_2.username] }
    end
    assert_not flash.empty?
    assert_redirected_to wad_path(@wad)
  end
end
