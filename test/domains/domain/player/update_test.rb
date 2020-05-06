require 'test_helper'

describe Domain::Player::Update do
  let(:player) { players(:elim) }
  let(:demo) { player.demos.first }
  let(:attributes) { { record_index: 1 } }

  before do
    Domain::Player::Save.stubs(:call)
    Domain::Demo::Update.stubs(:call)
  end

  it 'assigns attributes' do
    player.expects(:assign_attributes)
    Domain::Player::Update.call(player, attributes)
  end

  it 'saves the player' do
    Domain::Player::Save.expects(:call)
    Domain::Player::Update.call(player, attributes)
  end

  describe 'when the player is a cheater' do
    let(:attributes) { { cheater: true } }

    it 'sets the demos to suspect' do
      Domain::Demo::Update.expects(:call).with(demo, suspect: true)
      Domain::Player::Update.call(player, attributes)
    end
  end
end
