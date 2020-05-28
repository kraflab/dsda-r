require 'test_helper'

describe Admin do
  let(:admin) {
    Admin.new(username: username, password: password, fail_count: fail_count)
  }
  let(:username) { 'test_user' }
  let(:password) { 'test_password' }
  let(:fail_count) { 0 }

  describe 'validity' do
    it 'is valid' do
      _(admin).must_be:valid?
    end

    describe 'when the username is blank' do
      let(:username) { ' ' }

      it 'is invalid' do
        _(admin).wont_be :valid?
      end
    end

    describe 'when the username is too long' do
      let(:username) { 'a' * 51 }

      it 'is invalid' do
        _(admin).wont_be :valid?
      end
    end

    describe 'when the username has an invalid format' do
      [' me ', "a\tbc", 'hey$'].each do |invalid_username|
        it 'is invalid' do
          admin.username = invalid_username
          _(admin).wont_be :valid?
        end
      end
    end

    describe 'when the username is not unique' do
      let(:duplicate_admin) { admin.dup }

      it 'is invalid' do
        admin.save
        _(duplicate_admin).wont_be :valid?
      end
    end

    describe 'when the password is too short' do
      let(:password) { 'short' }

      it 'is invalid' do
        _(admin).wont_be :valid?
      end
    end
  end

  describe '#account_locked?' do
    it 'is false by default' do
      _(admin.account_locked?).must_equal false
    end

    describe 'after too many failed login attempts' do
      let(:fail_count) { Admin::LOGIN_FAIL_LIMIT }

      it 'is locked' do
        _(admin.account_locked?).must_equal true
      end
    end
  end

  describe '#fail_login!' do
    it 'updates the fail count' do
      assert_difference 'admin.fail_count', +1 do
        admin.fail_login!
      end
    end
  end

  describe '#try_authenticate' do
    let(:auth_password) { password }
    let(:try_authenticate) { admin.try_authenticate(auth_password) }

    describe 'when the password is correct' do
      describe 'and the account is not locked' do
        it 'returns the admin' do
          _(try_authenticate).must_equal admin
        end
      end

      describe 'but the account is locked' do
        let(:fail_count) { Admin::LOGIN_FAIL_LIMIT }

        it 'returns nil' do
          _(try_authenticate).must_be_nil
        end
      end
    end

    describe 'when the password is incorrect' do
      let(:auth_password) { 'wrong' }

      it 'returns nil' do
        _(try_authenticate).must_be_nil
      end

      it 'increments the fail count' do
        assert_difference 'admin.fail_count', +1 do
          try_authenticate
        end
      end
    end
  end
end
