require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @password = SecureRandom.base64(32)
    @username = 'cool_guy'
    @user = User.new(password: @password, username: @username)
  end

  test 'should be valid' do
    assert @user.valid?
  end

  test 'password must be long' do
    @user.password = SecureRandom.base64(16)
    assert_not @user.valid?
  end

  test 'cannot query by default' do
    @user.save!
    assert_not @user.reload.can_query
  end

  test 'cannot mutate by default' do
    @user.save!
    assert_not @user.reload.can_mutate
  end

  test 'authenticate' do
    assert @user.authenticate(@password)
    assert_not @user.authenticate(SecureRandom.base64(32))
  end
end
