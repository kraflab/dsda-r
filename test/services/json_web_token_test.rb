require 'test_helper'

describe JsonWebToken do
  let(:payload) {
    {
      iss: 'dsda',
      aud: 'dsda',
      sub: admin.id.to_s,
      exp: JsonWebToken::EXPIRATION_TIME.from_now.to_i
    }
  }
  let(:admin) { Admin.new(id: 1234) }
  let(:token) { JWT.encode(payload, JsonWebToken::SECRET_KEY) }

  describe '.encode' do
    it 'encodes the admin' do
      Timecop.freeze do
        JsonWebToken.encode(admin).must_equal token
      end
    end
  end

  describe '.decode' do
    let(:token) { JsonWebToken.encode(admin) }

    it 'decodes the token' do
      JsonWebToken.decode(token)[:sub].must_equal admin.id.to_s
    end

    describe 'when the token is bad' do
      let(:token) { 'foo-bad-wrong' }

      it 'raises an error' do
        proc {
          JsonWebToken.decode(token)
        }.must_raise JsonWebToken::DecodeError
      end
    end
  end
end
