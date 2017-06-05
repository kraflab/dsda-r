require 'test_helper'

class CompareMoviesTest < ActionDispatch::IntegrationTest

  test "should compare levelstats" do
    demo_a = demos(:btep1_a)
    demo_b = demos(:btep1_b)
    get compare_movies_path, params: {
      category: demo_a.category.name,
      id: demo_a.wad.username,
      level: demo_a.level
    }
    assert_response :success
    [demo_a, demo_b].each do |demo|
      demo.levelstat.split("\n").each do |time|
        assert_select "td", time
      end
    end
    assert_select "td", "5"
    assert_select "td", "-5"
  end
end
