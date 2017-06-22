require 'test_helper'

class WadsShowJSTest < CapybaraIntegrationTest

  def setup
    @admin = admins(:elim)
    @wad   = wads(:btsx)
    @pacifist = demos(:bt01pacifist)
  end

  test "heretic pacifist crosslist" do
    Capybara.current_driver = :webkit
    visit wad_path(wads(:xlist_test))
    page.assert_selector "td", text: demos(:xlist_pacifist).time, count: 2
  end

  test "demo javascript" do
    visit wad_path(@wad)
    demo = @wad.demos.first
    compat_demo = demos(:bt01pacifist_solo)
    page.assert_selector "td", text: @pacifist.time, count: 2
    page.assert_selector "td", text: compat_demo.time
    add_cookie page, "demo_filter", '{"category": ["UV Speed"]}'
    visit wad_path(@wad)
    page.assert_no_selector "td", text: demo.category.name
    add_cookie page, "demo_filter", '{compatibility: 1}'
    visit wad_path(@wad)
    page.assert_no_selector "td", text: compat_demo.time
  end
end
