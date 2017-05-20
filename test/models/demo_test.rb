require 'test_helper'

class DemoTest < ActiveSupport::TestCase

  def setup
    @wad = wads(:btsx)
    @category = categories(:uvspeed)
    @demo = Demo.new(wad: @wad, category: @category, tics: 99,
                     engine: "PRBoom+ v2.5.1.4", tas: 0, guys: 1,
                     has_tics: true, level: "Map 02",
                     recorded_at: 20.minutes.ago, levelstat: "0:00.99,1:11:00")
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

  test "tics must be positive" do
    @demo.tics = 0
    assert_not @demo.valid?
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

  test "must have tas" do
    @demo.tas = nil
    assert_not @demo.valid?
  end

  test "tas must be positive" do
    @demo.tas = -1
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
    @demo.level = "a" * 11
    assert_not @demo.valid?
  end

  test "does not need recorded_at" do
    @demo.recorded_at = nil
    assert @demo.valid?
  end

  test "must have levelstat" do
    @demo.levelstat = ""
    assert_not @demo.valid?
  end

  test "levelstat must not be too long" do
    @demo.levelstat = "a" * 501
    assert_not @demo.valid?
  end

  test "should show notes properly" do
    assert_match @demo.note.strip, ""
    @demo.guys = 2
    assert_match @demo.note.strip, "2P"
    @demo.tas = 3
    assert_match @demo.note.strip, "2P T3"
    @demo.guys = 1
    assert_match @demo.note.strip, "T3"
  end

  test "time text should be right" do
    assert_match @demo.time, "0:00.99"
  end

  test "should determine record properly" do
    demo01 = demos(:bt01speed)
    demo01p = demos(:bt01pacifist)
    demo02 = demos(:bt02speed)
    demo02_slow = demos(:bt02speed_slow)
    assert demo01p.is_record?
    assert_not demo01.is_record?
    assert demo02.is_record?
    assert_not demo02_slow.is_record?
  end
end
