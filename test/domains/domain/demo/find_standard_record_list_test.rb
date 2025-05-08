require 'test_helper'

describe Domain::Demo::FindStandardRecordList do
  let(:wad) { wads(:btsx) }
  let(:demo01) { demos(:bt01pacifist_solo) }
  let(:demo02) { demos(:bt02speed_solo) }

  it 'finds the standard records' do
    _(
      Domain::Demo::FindStandardRecordList
        .call(wad_id: wad.id, levels: ['Map 01', 'Map 02', 'Foo'], category_options: 'UV Speed')
    ).must_equal([['Map 01', demo01], ['Map 02', demo02], ['Foo', nil]])
  end
end
