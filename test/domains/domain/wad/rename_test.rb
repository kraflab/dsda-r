require 'test_helper'

describe Domain::Wad::Rename do
  let(:wad) { wads(:btsx) }
  let(:file) { demo_files(:demo_zip) }
  let(:new_name) { 'btsx_old' }
  let(:new_path) do
    Rails.root.join(
      "test/fixtures/public/files/demos/btsx_old/691518931/test0.zip"
    )
  end

  def rename
    Domain::Wad::Rename.call(wad, new_name)
  end

  before do
    wad.stubs(:demo_files).returns([file])
    file.data.file.expects(:move_to).with(new_path.to_s)
  end

  it 'renames the wad' do
    rename
    wad.reload.short_name.must_equal new_name
  end

  it 'moves files' do
    rename
    file.reload.data.url.include?(new_name).must_equal true
  end
end
