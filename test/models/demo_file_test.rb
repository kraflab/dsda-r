require 'test_helper'

class DemoFileTest < ActiveSupport::TestCase
  
  def setup
    @wad = wads(:btsx)
    @file = File.open(Rails.root.join("test/fixtures/files/test.zip"))
    @demo_file = DemoFile.new(wad: @wad, data: @file)
  end
  
  test "should be valid" do
    assert @demo_file.valid?
  end
  
  test "must have wad" do
    @demo_file.wad = nil
    assert_not @demo_file.valid?
  end
  
  test "must be unique" do
    @demo_file.save
    new_file = DemoFile.new(wad: @wad, data: @file)
    new_file.valid?
    assert_not new_file.valid?
  end
end
