require 'test_helper'

class PortTest < ActiveSupport::TestCase

  def setup
    @file = dummy_zip
    @port = Port.new(
      family: "PRBoom+", version: "v2.5.1.3", data: @file, md5: '1234'
    )
  end

  test "should be valid" do
    assert @port.valid?
  end

  test "family must be present" do
    @port.family = " "
    assert_not @port.valid?
  end

  test "version must be present" do
    @port.version = " "
    assert_not @port.valid?
  end

  test "family should not be too long" do
    @port.family = "a" * 51
    assert_not @port.valid?
  end

  test "version should not be too long" do
    @port.version = "a" * 51
    assert_not @port.valid?
  end

  test "version should match regex" do
    @port.version = "v\t1"
    assert_not @port.valid?
    @port.version = "v$%1"
    assert_not @port.valid?
    @port.version = "v-1+"
    assert @port.valid?
  end

  test "family should match regex" do
    @port.family = "v\t1"
    assert_not @port.valid?
    @port.family = "v$%1"
    assert_not @port.valid?
    @port.family = "v 1+"
    assert @port.valid?
  end

  test "family + version should be unique" do
    duplicate_port = @port.dup
    duplicate_port.data = dummy_zip 1
    duplicate_port.md5 = 'dup'
    @port.save
    assert_not duplicate_port.valid?
    duplicate_port.version = "v2.5.1.5"
    assert duplicate_port.valid?
    duplicate_port.version = @port.version
    duplicate_port.family = "GZDoom"
    assert duplicate_port.valid?
  end

  test "file must be unique" do
    @port.save
    new_port = Port.new(family: "ZDoom", version: "v2.0.50", data: @file)
    assert_not new_port.valid?
  end

  test "file must be present" do
    @port.data = nil
    assert_not @port.valid?
  end
end
