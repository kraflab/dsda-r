require 'test_helper'

describe Domain::Player::Create do
  let(:params) {
    {
      name: 'Adam Williamson',
      username: nil,
      twitch: nil,
      youtube: nil
    }
  }

  before do
    Domain::Player::Save.stubs(:call).returns(true)
  end

  it 'generates a username' do
    Player.expects(:new).with(params.merge(username: 'adam_williamson'))
    Domain::Player::Create.call(params)
  end

  it 'saves the player' do
    Domain::Player::Save.expects(:call).returns(true)
    Domain::Player::Create.call(params)
  end
end
