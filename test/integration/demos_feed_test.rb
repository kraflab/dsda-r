require 'test_helper'

class DemosFeedTest < ActionDispatch::IntegrationTest
  
  test "feed content" do
    get feed_path
    assert_response :success
    assert_select "h1", "Recent Demos"
    demos = Demo.reorder(created_at: :desc).paginate(page: nil)
    [demos.first, demos.last].each do |demo|
      assert_select "td", demo.created_at.to_date.to_s
      assert_select "a[href=?]", wad_path(demo.wad)
      assert_select "a[href=?]", iwad_path(demo.wad.iwad)
      assert_select "td", demo.level
      assert_select "td", demo.category.name
      assert_select "td", demo.players_text
      assert_select "td", demo.engine
      assert_select "td", demo.note
      assert_select "td", demo.time
    end
    assert_select "td", Demo.last.time, 0
    assert_select "div.pagination"
  end
end
