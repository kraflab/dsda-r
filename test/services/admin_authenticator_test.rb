require 'test_helper'

describe AdminAuthenticator do
  let(:request) {
    OpenStruct.new(
      headers: {
        'HTTP_API_USERNAME' => username,
        'HTTP_API_PASSWORD' => password
      }
    )
  }
  let(:admin) { admins(:elim) }
  let(:username) { admin.username }
  let(:password) { 'password1234' }
  let(:service) { AdminAuthenticator.new(request) }

  describe '#authenticate!' do
    let(:authenticate) { service.authenticate! }

    describe 'when the admin does not exist' do
      let(:username) { 'wrong' }

      it 'raises an error' do
        proc { authenticate }.must_raise Errors::Unauthorized
      end
    end

    describe 'when the admin exists' do
      describe 'and the password is correct' do
        it 'returns the admin' do
          authenticate.must_equal admin
        end
      end

      describe 'but the password is wrong' do
        let(:password) { 'wrong' }

        it 'raises an error' do
          proc { authenticate }.must_raise Errors::Unauthorized
        end
      end
    end
  end
end
