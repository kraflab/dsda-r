require 'test_helper'

class IwadsIndexTest < ActionDispatch::IntegrationTest
  
  def setup
    @admin = admins(:elim)
  end
  
  test "index layout" do
    get iwads_path
    assert_select "div.panel-heading", "List of Iwads"
    iwads = Iwad.all
    iwads.each do |iwad|
      assert_select 'a[href=?]', iwad_path(iwad)
    end
    assert_select 'a[href=?]', new_iwad_path, 0
    log_in_as(@admin)
    get iwads_path
    assert_select 'a[href=?]', new_iwad_path
  end
end
