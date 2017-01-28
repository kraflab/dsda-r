require 'test_helper'

class PlayerTest < ActiveSupport::TestCase
  
  def setup
    @player = Player.new(name: "Example Player", username: "exampleplayer",
                         twitch: "exampleplayer", youtube: "exampleplayer")
  end
  
  test "should be valid" do
    assert @player.valid?
  end
  
  test "name must be present" do
    @player.name = " "
    assert_not @player.valid?
  end
  
  test "username must be present" do
    @player.username = " "
    assert_not @player.valid?
  end
  
  test "name should not be too long" do
    @player.name = "a" * 51
    assert_not @player.valid?
  end
  
  test "username should not be too long" do
    @player.username = "a" * 51
    assert_not @player.valid?
  end
  
  test "twitch should not be too long" do
    @player.twitch = "a" * 51
    assert_not @player.valid?
  end
  
  test "youtube should not be too long" do
    @player.youtube = "a" * 51
    assert_not @player.valid?
  end
  
  test "social links can be absent" do
    @player.twitch  = " "
    @player.youtube = " "
    assert @player.valid?
  end
  
  test "username should be fixed" do
    @player.name = "  7x7 #Should be fixed\t\n"
    assert_equal "7x7_should_be_fixed", Player.default_username(@player.name)
  end
  
  test "username should match regex" do
    assert @player.valid?
    @player.username = " a "
    assert_not @player.valid?
    @player.username = "AAAA\t77"
    assert_not @player.valid?
    @player.username = "hello$world%"
    assert_not @player.valid?
    @player.username = "example user"
    assert_not @player.valid?
    @player.username = "ad4m_wi11i4ms0n"
    assert @player.valid?
  end
  
  test "social links should match regex" do
    bad_link  = "Bad Link"
    good_link = "good_link"
    @player.twitch = bad_link
    assert_not @player.valid?
    @player.twitch = good_link
    assert @player.valid?
    @player.youtube = bad_link
    assert_not @player.valid?
    @player.youtube = good_link
    assert @player.valid?
    @player.save
    assert_equal @player.reload.twitch,  good_link
    assert_equal @player.reload.youtube, good_link
  end
  
  test "username should be unique" do
    duplicate_player = @player.dup
    @player.save
    assert_not duplicate_player.valid?
  end
end
