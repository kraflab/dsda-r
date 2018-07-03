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

  describe '.single' do
    let(:player) { players(:elim) }

    it 'returns a player' do
      Domain::Player.single(username: player.username).must_equal player
    end
  end
end
