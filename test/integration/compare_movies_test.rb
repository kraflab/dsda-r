require 'test_helper'

class CompareMoviesTest < ActionDispatch::IntegrationTest

  def setup
    @demo_a = demos(:btep1_a)
    @demo_b = demos(:btep1_b)
  end

  test "should compare levelstats" do
    get compare_movies_path, params: {
      category: @demo_a.category.name,
      id: @demo_a.wad.short_name,
      level: @demo_a.level
    }
    assert_response :success
    [@demo_a, @demo_b].each do |demo|
      demo.levelstat.split("\n").each do |time|
        assert_select "td", time
      end
    end
    assert_select "td", "5"
    assert_select "td", "-5"
  end

  test "should respond to ajax" do
    get compare_movies_json_path, params: {
      category: @demo_a.category.name,
      id: @demo_a.wad.short_name,
      level: @demo_a.level,
      index_0: 0,
      index_1: 1
    }
    assert_response :success
    hash = JSON.parse(response.body)
    assert_equal hash['error'], false
    assert_not hash['times'].nil?
    assert_equal hash['times'].size, 2
    assert_equal hash['times'].first.size, 3
    assert_equal hash['times'].first[2], 5
  end
end
