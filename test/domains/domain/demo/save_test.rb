require 'test_helper'

describe Domain::Demo::Save do
  let(:demo) do
    Demo.new(
      levelstat: '1,2', guys: 1, tas: false,
      category: categories(:uvspeed), recorded_at: Time.now
    )
  end
  let(:demo_file) { Struct.new(:md5).new(nil) }
  let(:players) { [player] }
  let(:player) { mock() }
  let(:previous_players) { [previous_player] }
  let(:previous_player) { mock() }
  let(:tic_record) { true }
  let(:previous_record) { Demo.new }

  before do
    demo.stubs(:players).returns(players)
    demo.stubs(:demo_file).returns(demo_file)
    demo.stubs(:save!)
    demo.stubs(:tic_record?).returns(tic_record)
    player.stubs(:touch)
    previous_record.stubs(:players).returns(previous_players)
    Service::FileData::ComputeMd5.stubs(call: '1234')
    Domain::Demo::UpdateRecordFields.stubs(call: true)
    Domain::Player.stubs(refresh_record_index: true)
    Domain::Demo::FindStandardRecord.stubs(call: previous_record)
  end

  it 'assigns year' do
    Domain::Demo::Save.call(demo)
    demo.year.must_equal(demo.recorded_at.year)
  end

  it 'formats levelstat' do
    Domain::Demo::Save.call(demo)
    demo.levelstat.must_equal "1\n2"
  end

  it 'updates record fields' do
    Domain::Demo::UpdateRecordFields.expects(:call).with(demo)
    Domain::Demo::Save.call(demo)
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

  it 'updates affected players record index' do
    Domain::Player.expects(:refresh_record_index).with(players: players)
    Domain::Player.expects(:refresh_record_index).with(players: previous_players)
    Domain::Demo::Save.call(demo)
  end

  it 'touches the players' do
    player.expects(:touch)
    Domain::Demo::Save.call(demo)
  end
end
