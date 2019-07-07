require 'test_helper'

describe Domain::Player::RefreshRecordIndex do
  let(:refresh) {
    Domain::Player::RefreshRecordIndex.call([player])
  }

  before do
    Domain::Player::Update.stubs(:call)
  end

  describe 'when given a player' do
    let(:player) { players(:elim) }

    before do
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
