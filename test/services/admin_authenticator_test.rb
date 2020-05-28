require 'test_helper'

describe AdminAuthenticator do
  let(:request) {
    OpenStruct.new(
      headers: {
        'Authorization' => "Bearer #{token}"
      }
    )
  }
  let(:admin) { admins(:elim) }
  let(:token) { JsonWebToken.encode(admin) }
  let(:service) { AdminAuthenticator.new(request) }

  describe '#authenticate!' do
    let(:authenticate) { service.authenticate! }

    describe 'when the admin does not exist' do
      let(:admin) { Admin.new(id: 0) }

      it 'raises an error' do
        _(proc { authenticate }).must_raise Errors::Unauthorized
      end
    end

    describe 'when the token is bad' do
      let(:token) { 'bad-token' }

      it 'raises an error' do
        _(proc { authenticate }).must_raise Errors::Unauthorized
      end
    end

    describe 'when the token is correct and the admin exists' do
      describe 'and the password is correct' do
        it 'returns the admin' do
          _(authenticate).must_equal admin
        end
      end
    end

    describe 'deprecated authentication' do
      let(:request) {
        OpenStruct.new(
          headers: {
            'HTTP_API_USERNAME' => username,
            'HTTP_API_PASSWORD' => password
          }
        )
      }
      let(:username) { admin.username }
      let(:password) { 'password1234' }

      describe 'when the admin does not exist' do
        let(:username) { 'wrong' }

        it 'raises an error' do
          _(proc { authenticate }).must_raise Errors::Unauthorized
        end
      end

      describe 'when the admin exists' do
        describe 'and the password is correct' do
          it 'returns the admin' do
            _(authenticate).must_equal admin
          end
        end

        describe 'but the password is wrong' do
          let(:password) { 'wrong' }

          it 'raises an error' do
            _(proc { authenticate }).must_raise Errors::Unauthorized
          end
        end
      end
    end
  end
end
