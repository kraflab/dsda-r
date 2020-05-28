require 'test_helper'

describe Domain::Wad::Save do
  let(:wad) { Wad.new(author: ' jane  doe ', name: ' so  good ') }
  let(:wad_file) { Struct.new(:md5).new(nil) }

  before do
    wad.stubs(:wad_file).returns(wad_file)
    wad.stubs(:save!)
    Service::FileData::ComputeMd5.stubs(call: '1234')
  end

  it 'removes excess namespace' do
    Domain::Wad::Save.call(wad)
    _(wad.author).must_equal 'jane doe'
    _(wad.name).must_equal 'so good'
  end

  it 'saves the wad' do
    wad.expects(:save!)
    Domain::Wad::Save.call(wad)
  end

  it 'computes the file md5 hash' do
    Service::FileData::ComputeMd5.expects(:call).returns('1234')
    Domain::Wad::Save.call(wad)
    _(wad_file.md5).must_equal '1234'
  end
end
