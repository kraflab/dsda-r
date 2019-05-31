require 'test_helper'

class IwadTest < ActiveSupport::TestCase

  def setup
    @iwad = Iwad.new(name: "Chex Quest", short_name: "chex",
                                         author:   "Digital Café")
  end

  test "should be valid" do
    assert @iwad.valid?
  end

  test "name must be present" do
    @iwad.name = " "
    assert_not @iwad.valid?
  end

  test "short_name must be present" do
    @iwad.short_name = " "
    assert_not @iwad.valid?
  end

  test "author must be present" do
    @iwad.author = " "
    assert_not @iwad.valid?
  end

  test "name should not be too long" do
    @iwad.name = "a" * 51
    assert_not @iwad.valid?
  end

  test "short_name should not be too long" do
    @iwad.short_name = "a" * 51
    assert_not @iwad.valid?
  end

  test "author should not be too long" do
    @iwad.author = "a" * 51
    assert_not @iwad.valid?
  end

  test "short_name should match regex" do
    assert @iwad.valid?
    @iwad.short_name = " doom "
    assert_not @iwad.valid?
    @iwad.short_name = "doom\t77"
    assert_not @iwad.valid?
    @iwad.short_name = "doom$world%"
    assert_not @iwad.valid?
    @iwad.short_name = "Doom II"
    assert_not @iwad.valid?
    @iwad.short_name = "chexquest"
    assert @iwad.valid?
  end

  test "short_name should be unique" do
    duplicate_iwad = @iwad.dup
    @iwad.save
    assert_not duplicate_iwad.valid?
  end
end
