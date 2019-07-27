require 'test_helper'

describe Domain::Demo::Delete do
  let(:demo) { Demo.new(levelstat: '1,2') }
  let(:demo_file) { Struct.new(:demos).new(Struct.new(:count).new(count)) }
  let(:players) { [player] }
  let(:player) { mock() }
  let(:count) { 0 }

  before do
    demo_file.stubs(:destroy!)
    demo.stubs(:players).returns(players)
    demo.stubs(:demo_file).returns(demo_file)
    demo.stubs(:destroy!)
    player.stubs(:touch)
  end

  it 'touches the players' do
    player.expects(:touch)
    Domain::Demo::Delete.call(demo)
  end

  it 'destroys the demo' do
    demo.expects(:destroy!)
    Domain::Demo::Delete.call(demo)
  end

  it 'destroys the file' do
    demo_file.expects(:destroy!)
    Domain::Demo::Delete.call(demo)
  end

  describe 'when the file is associated with other demos' do
    let(:count) { 1 }

    it 'does not destroy the file' do
      demo_file.expects(:destroy!).never
      Domain::Demo::Delete.call(demo)
    end
  end
end
