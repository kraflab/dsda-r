require 'test_helper'

describe Domain::Player::RefreshRecordIndex do
  let(:refresh) {
    Domain::Player::RefreshRecordIndex.call(player: player)
  }

  before do
    Domain::Player::Update.stubs(:call)
  end

  describe 'when no players are provided' do
    let(:player) { nil }

    it 'raises error' do
      proc { refresh }.must_raise ArgumentError
    end
  end

  describe 'when given a player' do
    let(:player) { players(:elim) }
    let(:demos) { [mock(), mock()] }

    before do
      demos.first.stubs(:record_index).returns(1)
      demos.second.stubs(:record_index).returns(2)
      player.stubs(:demos).returns(demos)
      player.stubs(:record_index).returns(record_index)
    end

    describe 'when the record index has changed' do
      let(:record_index) { 0 }

      it 'updates the player' do
        Domain::Player::Update.expects(:call).with(player, record_index: 3)
        refresh
      end
    end

    describe 'when the record index has not changed' do
      let(:record_index) { 3 }

      it 'does not update the player' do
        Domain::Player::Update.expects(:call).never
        refresh
      end
    end
  end
end
