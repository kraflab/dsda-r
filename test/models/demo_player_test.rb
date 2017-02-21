require 'test_helper'

class DemoPlayerTest < ActiveSupport::TestCase
  
  def setup
    @player = players(:kraflab)
    @demo = demos(:bt02speed)
    @demo_player = DemoPlayer.new(player: @player, demo: @demo)
  end
  
  test "should be valid" do
    assert @demo_player.valid?
  end
  
  test "must have player" do
    @demo_player.player = nil
    assert_not @demo_player.valid?
  end
  
  test "must have demo" do
    @demo_player.demo = nil
    assert_not @demo_player.valid?
  end
end
