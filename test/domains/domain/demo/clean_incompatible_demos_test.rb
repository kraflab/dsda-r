require 'test_helper'

describe Domain::Demo::CleanIncompatibleDemos do
  let(:incompatible_demo) { demos(:record_demo) }
  let(:compatible_demo) { demos(:second_record_demo) }

  it 'sets the record fields' do
    Domain::Demo::CleanIncompatibleDemos.call(incompatible_demo.wad_id)
    _(incompatible_demo.reload.tic_record).must_equal(false)
    _(incompatible_demo.category_name).must_equal('Other')
    _(incompatible_demo.sub_categories.first.name).must_equal('Incompatible UV Speed')
    _(compatible_demo.reload.tic_record).must_equal(true)
    _(compatible_demo.category_name).must_equal('UV Speed')
  end
end
