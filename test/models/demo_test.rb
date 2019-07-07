require 'test_helper'

class DemoTest < ActiveSupport::TestCase

  def setup
    @demo = Demo.new(
      wad: wads(:btsx),
      category: categories(:uvspeed),
      tics: 99,
      engine: "PRBoom+ v2.5.1.4",
      tas: false,
      guys: 1,
      has_tics: true,
      level: "Map 02",
      recorded_at: 20.minutes.ago,
      levelstat: "0:00.99,1:11:00",
      demo_file: demo_files(:demo_zip),
      players: [players(:kraflab)]
    )
  end

  test "should be valid" do
    assert @demo.valid?
  end

  test "must have wad" do
    @demo.wad = nil
    assert_not @demo.valid?
  end

  test "must have category" do
    @demo.category = nil
    assert_not @demo.valid?
  end

  test "must have tics" do
    @demo.tics = nil
    assert_not @demo.valid?
  end

  test "tics must be nonnegative" do
    @demo.tics = 0
    assert @demo.valid?
    @demo.tics = -1
    assert_not @demo.valid?
  end

  test "must have engine" do
    @demo.engine = ""
    assert_not @demo.valid?
  end

  test "engine must not be too long" do
    @demo.engine = "a" * 51
    assert_not @demo.valid?
  end

  test "must have compatible" do
    @demo.compatible = nil
    assert_not @demo.valid?
  end

  test "must have tas" do
    @demo.tas = nil
    assert_not @demo.valid?
  end

  test "must have guys" do
    @demo.guys = nil
    assert_not @demo.valid?
  end

  test "guys must be positive" do
    @demo.guys = 0
    assert_not @demo.valid?
    @demo.guys = -1
    assert_not @demo.valid?
  end

  test "must have level" do
    @demo.level = ""
    assert_not @demo.valid?
  end

  test "level must not be too long" do
    @demo.level = "a" * 13
    assert_not @demo.valid?
  end

  test "does not need recorded_at" do
    @demo.recorded_at = nil
    assert @demo.valid?
  end

  test "levelstat must not be too long" do
    @demo.levelstat = "a" * 501
    assert_not @demo.valid?
  end

  test "should show notes properly" do
    assert_match @demo.note.strip, ""
    @demo.guys = 2
    assert_match @demo.note.strip, "2P"
    @demo.tas = true
    assert_match @demo.note.strip, "2P\nTAS"
    @demo.guys = 1
    assert_match @demo.note.strip, "TAS"
  end

  test "time text should be right" do
    assert_match @demo.time, "0:00.99"
  end

  test "standard?" do
    @demo.assign_attributes(tas: false, guys: 1)
    assert_equal true, @demo.standard?
    @demo.assign_attributes(tas: true, guys: 1)
    assert_equal false, @demo.standard?
    @demo.assign_attributes(tas: false, guys: 2)
    assert_equal false, @demo.standard?
    @demo.assign_attributes(tas: true, guys: 2)
    assert_equal false, @demo.standard?
  end
end
