require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  test "home page content and links" do
    get root_path
    assert_select "title", "Home | DSDA"
    assert_select "div.panel"
    assert_select "div.panel-heading", "Demo Categories & Types"
    assert_select "div.panel-heading", "Recording & Playback"
    assert_select "td", "Exit as fast as possible on skill 4."
    assert_select "a[href=?]", players_url
    assert_select "a[href=?]", iwads_url
    assert_select "a[href=?]", wads_url
    assert_select "a[href=?]", ports_url
    assert_select "a[href=?]", stats_url
    assert_select "a[href=?]", settings_url
    assert_select "a[href=?]", about_url
    assert_select "a[href=?]", "https://www.doomworld.com/forum/37-doom-speed-demos/"
  end

  test "stats page" do
    get stats_path
    assert_select "title", "Stats | DSDA"
    assert_select "div.page-header", "Stats & Charts"
    assert_select "div.chart-style[id=?]", "wad_count_by_iwad"
    assert_select "div.chart-style[id=?]", "demo_count_by_month"
  end

  test "about page" do
    get about_path
    assert_match "Andy Olivera", response.body
    assert_match "Opulent", response.body
    assert_select "h1", "History"
  end
end
