require 'test_helper'

describe Domain::Wad::TableLevelList do
  let(:wad) { wads(:btsx) }

  it 'returns the relevant level list' do
    Domain::Wad::TableLevelList.call(wad, 'UV Speed')
      .include?('Map 02s').must_equal(true)
    Domain::Wad::TableLevelList.call(wad, 'UV Max')
      .include?('Map 02s').must_equal(false)
  end
end
