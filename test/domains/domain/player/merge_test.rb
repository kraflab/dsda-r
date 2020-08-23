require 'test_helper'

describe Domain::Player::Merge do
  let(:from) { players(:kingdime) }
  let(:into) { players(:elim) }

  it 'merges the record index' do
    sum = from.record_index + into.record_index
    Domain::Player::Merge.call(from: from, into: into)
    _(into.record_index).must_equal(sum)
  end

  it 'merges the demos' do
    sum = from.demos.count + into.demos.count
    Domain::Player::Merge.call(from: from, into: into)
    _(into.demos.count).must_equal(sum)
  end

  it 'does not change the demo player count' do
    assert_no_difference 'DemoPlayer.count' do
      Domain::Player::Merge.call(from: from, into: into)
    end
  end

  it 'deletes the from' do
    from_id = from.id
    Domain::Player::Merge.call(from: from, into: into)
    assert_nil Player.find_by(id: from_id)
  end

  describe 'aliases' do
    before do
      PlayerAlias.create(player_id: from.id, name: 'fake_alias')
    end

    it 'creates aliases' do
      Domain::Player::Merge.call(from: from, into: into)
      _(
        PlayerAlias.find_by(name: from.name, player_id: into.id)
      ).must_be_instance_of PlayerAlias
      _(
        PlayerAlias.find_by(name: 'fake_alias', player_id: into.id)
      ).must_be_instance_of PlayerAlias
    end
  end
end
