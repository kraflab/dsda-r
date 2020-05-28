require 'test_helper'

describe Domain::Player::MoveDemos do
  let(:to_player) { players(:elim) }
  let(:from_player) { players(:kraflab) }
  let(:total) { to_player.demos.count + from_player.demos.count }

  it 'moves demos from one player to the other' do
    assert total.positive?
    Domain::Player::MoveDemos.call(
      from_player: from_player, to_player: to_player
    )
    _(from_player.demos.count).must_equal 0
    _(to_player.demos.count).must_equal total
  end
end
