require 'test_helper'

describe Domain::Demo::Save do
  let(:demo) do
    Demo.new(
      levelstat: '1,2', guys: 1, tas: false, level: 'E1M3s',
      category: categories(:uvmax), recorded_at: Time.now
    )
  end
  let(:demo_file) { Struct.new(:md5).new(nil) }
  let(:players) { [player] }
  let(:player) { mock() }
  let(:previous_players) { [previous_player] }
  let(:previous_player) { mock() }
  let(:tic_record) { true }
  let(:previous_record) { Demo.new }
  let(:cheater) { false }

  before do
    demo.stubs(:players).returns(players)
    demo.stubs(:demo_file).returns(demo_file)
    demo.stubs(:save!)
    demo.stubs(:tic_record?).returns(tic_record)
    player.stubs(:touch)
    player.stubs(cheater?: cheater)
    previous_record.stubs(:players).returns(previous_players)
    Service::FileData::ComputeMd5.stubs(call: '1234')
    Domain::Demo::UpdateRecordFields.stubs(call: true)
    Domain::Player.stubs(refresh_record_index: true)
    Domain::Demo::FindStandardRecord.stubs(call: previous_record)
  end

  it 'assigns year' do
    Domain::Demo::Save.call(demo)
    _(demo.year).must_equal(demo.recorded_at.year)
  end

  it 'formats levelstat' do
    Domain::Demo::Save.call(demo)
    _(demo.levelstat).must_equal "1\n2"
  end

  it 'formats level' do
    Domain::Demo::Save.call(demo)
    _(demo.level).must_equal "E1M3"
  end

  it 'updates record fields' do
    Domain::Demo::UpdateRecordFields.expects(:call).with(demo)
    Domain::Demo::Save.call(demo)
  end

  it 'does not set suspect' do
    Domain::Demo::Save.call(demo)
    _(demo.suspect).must_equal false
  end

  describe 'when a player is a cheater' do
    let(:cheater) { true }

    it 'sets the demo suspect' do
      Domain::Demo::Save.call(demo)
      _(demo.suspect).must_equal true
    end
  end

  describe 'when given an old run too' do
    describe 'when the old run is the same' do
      let(:old_run) { Domain::Demo::Run.new(demo) }

      it 'only updates the record fields for the demo' do
        Domain::Demo::UpdateRecordFields.expects(:call).with(demo)
        Domain::Demo::Save.call(demo, old_run)
      end
    end

    describe 'when the old run is different' do
      it 'updates the record fields for both' do
        old_run = Domain::Demo::Run.new(demo)
        demo.wad_id = 999
        Domain::Demo::UpdateRecordFields.expects(:call).with(demo)
        Domain::Demo::UpdateRecordFields.expects(:call).with(old_run)
        Domain::Demo::Save.call(demo, old_run)
      end
    end
  end

  it 'saves the demo' do
    demo.expects(:save!)
    Domain::Demo::Save.call(demo)
  end

  it 'computes the file md5 hash' do
    Service::FileData::ComputeMd5.expects(:call).returns('1234')
    Domain::Demo::Save.call(demo)
    _(demo_file.md5).must_equal '1234'
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
