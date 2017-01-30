require 'test_helper'

class IwadTest < ActiveSupport::TestCase
  
  def setup
    @iwad = Iwad.new(name: "Chex Quest", username: "chex",
                                         author:   "Digital Café")
  end
  
  test "should be valid" do
    assert @iwad.valid?
  end
  
  test "name must be present" do
    @iwad.name = " "
    assert_not @iwad.valid?
  end
  
  test "username must be present" do
    @iwad.username = " "
    assert_not @iwad.valid?
  end
  
  test "author must be present" do
    @iwad.author = " "
    assert_not @iwad.valid?
  end
  
  test "name should not be too long" do
    @iwad.name = "a" * 51
    assert_not @iwad.valid?
  end
  
  test "username should not be too long" do
    @iwad.username = "a" * 51
    assert_not @iwad.valid?
  end
  
  test "author should not be too long" do
    @iwad.author = "a" * 51
    assert_not @iwad.valid?
  end
  
  test "username should match regex" do
    assert @iwad.valid?
    @iwad.username = " doom "
    assert_not @iwad.valid?
    @iwad.username = "doom\t77"
    assert_not @iwad.valid?
    @iwad.username = "doom$world%"
    assert_not @iwad.valid?
    @iwad.username = "Doom II"
    assert_not @iwad.valid?
    @iwad.username = "chexquest"
    assert @iwad.valid?
  end
  
  test "username should be unique" do
    duplicate_iwad = @iwad.dup
    @iwad.save
    assert_not duplicate_iwad.valid?
  end
end
