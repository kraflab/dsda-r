require 'test_helper'

describe Domain::Wad::TableLevelList do
  let(:wad) { wads(:btsx) }

  it 'returns the relevant level list' do
    _(
      Domain::Wad::TableLevelList.call(wad, 'UV Speed').include?('Map 02s')
    ).must_equal(true)
    _(
      Domain::Wad::TableLevelList.call(wad, 'UV Max').include?('Map 02s')
    ).must_equal(false)
  end
end
