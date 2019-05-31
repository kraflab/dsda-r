require 'test_helper'

class WadTest < ActiveSupport::TestCase

  def setup
    @iwad = iwads(:doom)
    @wad  = @iwad.wads.build(name: "Back to Saturn X 2", short_name: "btsx2",
                                                       author:   "Various")
  end

  test "should be valid" do
    @wad.save
    puts @wad.errors.full_messages
    assert @wad.valid?
  end

  test "name must be present" do
    @wad.name = " "
    assert_not @wad.valid?
  end

  test "short_name must be present" do
    @wad.short_name = " "
    assert_not @wad.valid?
  end

  test "author must be present" do
    @wad.author = " "
    assert_not @wad.valid?
  end

  test "name should not be too long" do
    @wad.name = "a" * 51
    assert_not @wad.valid?
  end

  test "short_name should not be too long" do
    @wad.short_name = "a" * 51
    assert_not @wad.valid?
  end

  test "author should not be too long" do
    @wad.author = "a" * 51
    assert_not @wad.valid?
  end

  test "short_name should match regex" do
    assert @wad.valid?
    @wad.short_name = " doom "
    assert_not @wad.valid?
    @wad.short_name = "doom\t77"
    assert_not @wad.valid?
    @wad.short_name = "doom$world%"
    assert_not @wad.valid?
    @wad.short_name = "Doom II"
    assert_not @wad.valid?
    @wad.short_name = "chexquest"
    assert @wad.valid?
  end

  test "short_name should be unique" do
    duplicate_wad = @wad.dup
    @wad.save
    assert_not duplicate_wad.valid?
  end

  test "must have iwad" do
    @wad.iwad_id = nil
    assert_not @wad.valid?
  end
end
