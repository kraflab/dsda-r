require 'test_helper'

describe Domain::Demo::Create do
  let(:params) {
    {
      time: '1:11.13',
      tas: false,
      guys: 1,
      level: 'E1M1',
      recorded_at: '2018-03-15 23:08:46 +0100',
      levelstat: '',
      engine: 'ZDoom v2.7',
      version: 0,
      video_link: 'xyz',
      wad: wads(:btsx),
      category: categories(:uvspeed),
      players: [players(:kraflab), players(:kingdime)],
      tags: [{ text: 'Also reality', show: 1 }],
      file: { data: '1234', name: 'test_demo.zip' },
      file_id: file_id,
      kills: '7/7',
      items: '0/42',
      secrets: '3/5'
    }
  }
  let(:file_id) { nil }
  let(:data) { '1234' }

  before do
    Service::FileData::Read.stubs(:call).returns(data)
    Domain::Demo::Save.stubs(:call).returns(true)
    Domain::Demo::CreateTags.stubs(:call).returns(true)
  end

  it 'reads file data' do
    Service::FileData::Read.expects(:call)
      .with(file_hash: params[:file]).returns(data)
    Domain::Demo::Create.call(params)
  end

  it 'saves the demo' do
    Domain::Demo::Save.expects(:call).returns(true)
    Domain::Demo::Create.call(params)
  end

  it 'creates tags' do
    Domain::Demo::CreateTags.expects(:call)
    Domain::Demo::Create.call(params)
  end

  describe 'when a file id is passed' do
    let(:file_id) { demo_files(:demo_zip).id }

    it 'associates the existing wad file' do
      Domain::Demo::Create.call(params).demo_file_id.must_equal file_id
    end
  end
end
