require 'test_helper'

class WadFileTest < ActiveSupport::TestCase

  def setup
    @iwad = iwads(:doom2)
    @file = dummy_zip
    @wad_file = WadFile.new(
      iwad: @iwad,
      data: @file,
      base_path: @iwad.short_name,
      md5: 'wad_file'
    )
  end

  test "should be valid" do
    assert @wad_file.valid?
  end

  test "must have iwad" do
    @wad_file.iwad = nil
    assert_not @wad_file.valid?
  end

  test "must be unique" do
    @wad_file.save
    new_file = WadFile.new(
      iwad: @iwad,
      data: @file,
      base_path: @iwad.short_name,
      md5: 'wad_file'
    )
    assert_not new_file.valid?
  end
end
