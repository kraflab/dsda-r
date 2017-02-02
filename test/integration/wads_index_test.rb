require 'test_helper'

class WadsIndexTest < ActionDispatch::IntegrationTest
  
  def setup
    @admin = admins(:elim)
  end
  
  test "index layout" do
    get wads_path
    assert_select "div.panel-heading", "List of Wads"
    wads = Wad.all
    wads.each do |wad|
      assert_select 'a[href=?]', wad_path(wad)
    end
    assert_select 'a[href=?]', new_wad_path, 0
    ('a'..'z').to_a.each do |letter|
      get wads_path(:letter => letter)
      wads = Wad.where("username LIKE ?", "#{letter}%")
      wads.each do |wad|
        assert_select 'a[href=?]', wad_path(wad)
      end
    end
    log_in_as(@admin)
    get wads_path
    assert_select 'a[href=?]', new_wad_path
  end
end
