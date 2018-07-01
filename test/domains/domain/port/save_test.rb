require 'test_helper'

describe Domain::Port::Save do
  let(:port) { Port.new(family: ' family  name ') }

  before do
    port.stubs(:save!)
  end

  it 'removes excess namespace in family' do
    Domain::Port::Save.call(port)
    port.family.must_equal 'family name'
  end

  it 'saves the port' do
    port.expects(:save!)
    Domain::Port::Save.call(port)
  end
end
