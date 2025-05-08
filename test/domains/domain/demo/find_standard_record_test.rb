require 'test_helper'

describe Domain::Demo::FindStandardRecord do
  let(:wad) { wads(:btsx) }
  let(:demo) { demos(:bt01pacifist_solo) }

  it 'finds the standard record' do
    _(
      Domain::Demo::FindStandardRecord
        .call(wad_id: wad.id, level: 'Map 01', category_options: 'UV Speed')
    ).must_equal(demo)
  end
end
