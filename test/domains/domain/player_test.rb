require 'test_helper'

describe Domain::Player do
  describe '.create' do
    it 'delegates player creation' do
      Domain::Player::Create.expects(:call)
      Domain::Player.create(name: 'Adam Williamson')
    end
  end

  describe '.list' do
    it 'returns a list of players' do
      Domain::Player.list.first.must_be_instance_of Player
    end
  end

  describe '.search' do
    let(:player) { players(:elim) }

    it 'returns players matching a search term' do
      Domain::Player.search(term: player.username).first.must_equal player
    end
  end

  describe '.single' do
    let(:player) { players(:elim) }

    it 'returns a player' do
      Domain::Player.single(username: player.username).must_equal player
    end

    describe 'when the player does not exist' do
      let(:single) {
        Domain::Player.single(username: 'not found', assert: assert_presence)
      }

      describe 'when asserting presence' do
        let(:assert_presence) { true }

        it 'raises error' do
          proc { single }.must_raise ActiveRecord::RecordNotFound
        end
      end

      describe 'when not asserting presence' do
        let(:assert_presence) { false }

        it 'returns nil' do
          single.must_be_nil
        end
      end
    end
  end

  describe '.refresh_record_index' do
    let(:refresh) {
      Domain::Player.refresh_record_index(player: player)
    }

    before do
      Domain::Player::RefreshRecordIndex.stubs(:call)
    end

    describe 'when no player is provided' do
      let(:player) { nil }

      it 'raises error' do
        proc { refresh }.must_raise ArgumentError
      end
    end

    describe 'when a player is provided' do
      let(:player) { :player }

      it 'refreshes its record index' do
        Domain::Player::RefreshRecordIndex.expects(:call).with([player])
        refresh
      end
    end
  end
end
