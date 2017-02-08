require 'test_helper'

class PortTest < ActiveSupport::TestCase
  
  def setup
    @port = Port.new(family: "PRBoom+", version: "v2.5.1.3", file: "")
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
    @port.version = " v1 "
    assert_not @port.valid?
    @port.version = "v\t1"
    assert_not @port.valid?
    @port.version = "v$%1"
    assert_not @port.valid?
    @port.version = "v 1"
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
    @port.save
    assert_not duplicate_port.valid?
    duplicate_port.version = "v2.5.1.5"
    assert duplicate_port.valid?
    duplicate_port.version = @port.version
    duplicate_port.family = "GZDoom"
    assert duplicate_port.valid?
  end
end
