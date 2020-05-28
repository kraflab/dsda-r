require 'test_helper'

describe Service::FileData::Read do
  let(:file_hash) {
    {
      data: data,
      name: 'zip.zip'
    }
  }
  let(:read_data) { Service::FileData::Read.call(file_hash: file_hash) }

  describe 'when the file data exists' do
    let(:data) { '1234' }

    it 'reads the file data' do
      _(read_data.read).must_equal Base64.decode64(data)
      _(read_data.original_filename).must_equal 'zip.zip'
    end
  end
end
