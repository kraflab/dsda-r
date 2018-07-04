require 'test_helper'

describe Domain::Player::Update do
  let(:player) { players(:elim) }
  let(:attributes) { { record_index: 1 } }

  before do
    player.stubs(:assign_attributes)
    Domain::Player::Save.stubs(:call)
  end

  it 'assigns attributes' do
    player.expects(:assign_attributes)
    Domain::Player::Update.call(player, attributes)
  end

  it 'saves the player' do
    Domain::Player::Save.expects(:call)
    Domain::Player::Update.call(player, attributes)
  end
end
