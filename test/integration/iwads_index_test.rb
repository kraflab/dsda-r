require 'test_helper'

class IwadsIndexTest < ActionDispatch::IntegrationTest

  def setup
    @admin = admins(:elim)
  end

  test "index layout" do
    get iwads_path
    assert_select "h1", "Iwad List"
    iwads = Iwad.all
    iwads.each do |iwad|
      assert_select 'a[href=?]', iwad_path(iwad)
      assert_select 'td', iwad.wads.count.to_s
    end
  end
end
