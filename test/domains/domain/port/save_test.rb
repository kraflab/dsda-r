require 'test_helper'

describe Domain::Port::Save do
  let(:port) { Port.new(family: ' family  name ') }

  before do
    port.stubs(:save!)
    Service::FileData::ComputeMd5.stubs(call: '1234')
  end

  it 'removes excess namespace in family' do
    Domain::Port::Save.call(port)
    port.family.must_equal 'family name'
  end

  it 'saves the port' do
    port.expects(:save!)
    Domain::Port::Save.call(port)
  end

  it 'computes the file md5 hash' do
    Service::FileData::ComputeMd5.expects(:call).returns('1234')
    Domain::Port::Save.call(port)
    port.md5.must_equal '1234'
  end
end
