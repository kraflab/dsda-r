require 'test_helper'

describe PlayerCreationService do
  let(:params) {
    {
      name: 'Bram Stoker',
      username: 'dracula',
      twitch: 'vampire',
      youtube: 'bramstoker'
    }
  }
  let(:service) { PlayerCreationService.new(params) }

  describe '#create!' do
    let(:create) { service.create! }

    describe 'when the params are valid' do
      it 'creates a player' do
        assert_difference 'Player.count', +1 do
          create
        end
      end

      it 'returns the player' do
        create.must_be_instance_of Player
      end
    end

    describe 'when the params are invalid' do
      let(:params) { { oops: 'nothing' } }

      it 'raises an error' do
        proc { create }.must_raise ActiveRecord::RecordInvalid
      end
    end
  end
end
