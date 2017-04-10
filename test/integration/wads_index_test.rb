require 'test_helper'

class WadsIndexTest < ActionDispatch::IntegrationTest
  
  def setup
    @admin = admins(:elim)
    @iwad  = iwads(:doom)
  end
  
  test "index layout" do
    get wads_path
    assert_select "h1", "Wad List"
    assert_select "nav.pagination"
    wads = Wad.page '0'
    wads.each do |wad|
      assert_select 'a[href=?]', wad_path(wad)
    end
    assert_select 'a[href=?]', new_wad_path, count: 0
    ('a'..'z').to_a.each do |letter|
      get wads_path, params: { letter: letter }
      wads = Wad.where("username LIKE ?", "#{letter}%")
      wads.each do |wad|
        assert_select 'a[href=?]', wad_path(wad)
        assert_select 'td', wad.demos.count.to_s
        assert_select 'td', total_demo_time(wad, false)
      end
      assert_select "nav.pagination", count: 0
    end
    log_in_as(@admin)
    get wads_path
    assert_select 'a[href=?]', new_wad_path
  end
end
