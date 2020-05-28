require 'test_helper'

describe Domain::Player::Save do
  let(:player) { Player.new(name: ' first  last ') }

  before do
    player.stubs(:save!)
  end

  it 'removes excess space in name' do
    Domain::Player::Save.call(player)
    _(player.name).must_equal 'first last'
  end

  it 'saves the player' do
    player.expects(:save!)
    Domain::Player::Save.call(player)
  end

  it 'sets default social links' do
    Domain::Player::Save.call(player)
    _(player.youtube).must_equal ''
    _(player.twitch).must_equal ''
  end

  describe 'when changing the player name' do
    let(:player) { players(:elim) }
    let(:demos) { [demo] }
    let(:demo) { mock() }

    before do
      player.name = 'new name'
      player.stubs(:demos).returns(demos)
    end

    it 'touches the demos' do
      demo.expects(:touch)
      Domain::Player::Save.call(player)
    end
  end
end
