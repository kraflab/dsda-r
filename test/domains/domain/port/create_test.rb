require 'test_helper'

describe Domain::Port::Create do
  let(:params) {
    {
      family: 'zdoom',
      version: 'v2.7',
      file: { data: '1234', name: 'zdoom.zip' }
    }
  }
  let(:data) { '1234' }

  before do
    Service::FileData::Read.stubs(:call).returns(data)
    Domain::Port::Save.stubs(:call).returns(true)
  end

  it 'reads file data' do
    Service::FileData::Read.expects(:call)
      .with(file_hash: params[:file]).returns(data)
    Domain::Port::Create.call(**params)
  end

  it 'saves the port' do
    Domain::Port::Save.expects(:call).returns(true)
    Domain::Port::Create.call(**params)
  end
end
