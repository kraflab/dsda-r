require 'test_helper'

describe Service::FileData::ComputeMd5 do
  let(:md5) { Service::FileData::ComputeMd5.call(object) }

  describe 'when the object has file data' do
    # stub object.data.file.[file, read]
    let(:object) {
      stub(data: stub(file: stub(file: true, read: '1234')))
    }

    it 'returns the md5' do
      _(md5).must_equal Digest::MD5.hexdigest('1234')
    end
  end

  describe 'when the object has no file data' do
    let(:object) { stub(data: nil) }

    it 'returns nil' do
      _(md5).must_be_nil
    end
  end
end
