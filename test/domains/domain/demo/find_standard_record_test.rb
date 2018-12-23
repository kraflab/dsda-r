require 'test_helper'

describe Domain::Demo::FindStandardRecord do
  let(:wad) { wads(:btsx) }
  let(:demo) { demos(:bt01pacifist_solo) }

  it 'finds the standard record' do
    Domain::Demo::FindStandardRecord
      .call(wad.id, 'Map 01', 'UV Speed')
      .must_equal(demo)
  end
end
