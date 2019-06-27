require 'test_helper'

class SubCategoryTest < ActiveSupport::TestCase

  def setup
    @sub = SubCategory.new(name: "sr40 only")
  end

  test "should be valid" do
    assert @sub.valid?
  end

  test "name must be present" do
    @sub.name = " "
    assert_not @sub.valid?
  end

  test "name should not be too long" do
    @sub.name = "a" * 201
    assert_not @sub.valid?
  end
end
