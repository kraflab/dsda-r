require 'test_helper'

describe Domain::Demo::FindMatches do
  let(:result) { Domain::Demo::FindMatches.call(details) }

  describe 'when finding nothing' do
    let(:details) do
      {
        wad: 'unknown',
        level: 'Map 01',
        category: 'UV Speed'
      }
    end

    it 'returns an empty array' do
      result.must_equal([])
    end
  end

  describe 'when finding one match' do
    let(:details) do
      {
        player: 'kingdime',
        wad: 'btsx',
        time: '9.99',
        level: 'Map 01',
        category: 'UV Speed'
      }
    end
    let(:demo) { demos(:bt01speed) }

    it 'finds matches' do
      result.count.must_equal(1)
      result.first.must_equal(demo)
    end
  end

  describe 'when finding multiple matches' do
    let(:details) do
      {
        wad: 'btsx',
        level: 'Map 01',
        category: 'Pacifist'
      }
    end

    it 'returns all matches' do
      result.count.must_equal(2)
    end

    describe 'when restricting by flags' do
      let(:details) do
        {
          wad: 'btsx',
          level: 'Map 01',
          category: 'Pacifist',
          tas: false,
          coop: true,
          solo_net: false
        }
      end
      let(:demo) { demos(:bt01pacifist) }

      it 'finds the right match' do
        result.count.must_equal(1)
        result.first.must_equal(demo)
      end
    end
  end
end
