require 'test_helper'

class DemosFeedTest < ActionDispatch::IntegrationTest

  test "feed content" do
    {updated_at: 'update_date', recorded_at: 'record_date'}.each do |sort_sym, query|
      get feed_path, params: {sort_by: query }
      assert_response :success
      assert_select "h1", "Recent Updates"
      demos = Demo.reorder(sort_sym => :desc).page '1'
      [demos.first, demos.last].each do |demo|
        assert_select "td", demo.send(sort_sym).to_date.to_s
        assert_select "a[href=?]", wad_path(demo.wad)
        assert_select "a[href=?]", iwad_path(demo.wad.iwad)
        assert_select "td", demo.level
        assert_select "td", demo.category.name
        assert_select "td", demo.players_text
        assert_select "td", demo.engine
        assert_select "td", demo.note.strip
        assert_select "td", demo.time
      end
      assert_select "td", text: Demo.reorder(sort_sym => :desc).last.time, count: 0
      assert_select "nav.pagination"
    end
  end
end
