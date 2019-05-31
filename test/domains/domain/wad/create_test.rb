require 'test_helper'

describe Domain::Wad::Create do
  let(:params) {
    {
      name: 'test_wad',
      short_name: 'test_wad',
      author: 'test_author',
      year: '2020',
      compatibility: 0,
      is_commercial: false,
      single_map: false,
      iwad: iwads(:doom),
      file: { data: '1234', name: 'test_wad.zip' },
      file_id: file_id
    }
  }
  let(:file_id) { nil }
  let(:data) { '1234' }

  before do
    Service::FileData::Read.stubs(:call).returns(data)
    Domain::Wad::Save.stubs(:call).returns(true)
  end

  it 'reads file data' do
    Service::FileData::Read.expects(:call)
      .with(file_hash: params[:file]).returns(data)
    Domain::Wad::Create.call(params)
  end

  it 'saves the wad' do
    Domain::Wad::Save.expects(:call).returns(true)
    Domain::Wad::Create.call(params)
  end

  describe 'when a file id is passed' do
    let(:file_id) { wad_files(:btsx_zip).id }

    it 'associates the existing wad file' do
      Domain::Wad::Create.call(params).wad_file_id.must_equal file_id
    end
  end
end
