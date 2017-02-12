require 'test_helper'

class SubCategoryTest < ActiveSupport::TestCase
  
  def setup
    @sub = SubCategory.new(name: "sr40 only", style: 2)
  end
  
  test "should be valid" do
    assert @sub.valid?
  end
  
  test "name must be present" do
    @sub.name = " "
    assert_not @sub.valid?
  end
  
  test "style must be present" do
    @sub.style = nil
    assert_not @sub.valid?
  end
  
  test "name should not be too long" do
    @sub.name = "a" * 51
    assert_not @sub.valid?
  end
  
  test "style should be > 0" do
    @sub.style = 0
    assert_not @sub.valid?
  end
  
  test "style change should work" do
    assert_not @sub.show?
    @sub.show
    assert @sub.show?
  end
end
