require 'test_helper'

class AdminTest < ActiveSupport::TestCase
  
  def setup
    @admin = Admin.new(username: "test", password: "password1234")
  end
  
  test "should be valid" do
    assert @admin.valid?
  end
  
  test "username must be present" do
    @admin.username = " "
    assert_not @admin.valid?
  end
  
  test "username should not be too long" do
    @admin.username = "a" * 51
    assert_not @admin.valid?
  end
  
  test "username should match regex" do
    assert @admin.valid?
    @admin.username = " a "
    assert_not @admin.valid?
    @admin.username = "AAAA\t77"
    assert_not @admin.valid?
    @admin.username = "hello$world%"
    assert_not @admin.valid?
    @admin.username = "example user"
    assert_not @admin.valid?
    @admin.username = "ad4m_wi11i4ms0n"
    assert @admin.valid?
  end
  
  test "username should be unique" do
    duplicate_player = @admin.dup
    @admin.save
    assert_not duplicate_player.valid?
  end
  
  test "password should have a minimum length" do
    @admin.password = @admin.password_confirmation = "a" * 11
    assert_not @admin.valid?
  end
end
