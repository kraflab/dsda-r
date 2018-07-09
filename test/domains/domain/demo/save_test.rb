require 'test_helper'

describe Domain::Demo::Save do
  let(:demo) { Demo.new(levelstat: '1,2') }
  let(:demo_file) { Struct.new(:md5).new(nil) }
  let(:players) { [player] }
  let(:player) { mock() }

  before do
    demo.stubs(:players).returns(players)
    demo.stubs(:demo_file).returns(demo_file)
    demo.stubs(:save!)
    player.stubs(:touch)
    Service::FileData::ComputeMd5.stubs(call: '1234')
  end

  it 'formats levelstat' do
    Domain::Demo::Save.call(demo)
    demo.levelstat.must_equal "1\n2"
  end

  it 'saves the demo' do
    demo.expects(:save!)
    Domain::Demo::Save.call(demo)
  end

  it 'computes the file md5 hash' do
    Service::FileData::ComputeMd5.expects(:call).returns('1234')
    Domain::Demo::Save.call(demo)
    demo_file.md5.must_equal '1234'
  end

  it 'touches the players' do
    player.expects(:touch)
    Domain::Demo::Save.call(demo)
  end
end
