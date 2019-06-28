require 'test_helper'

describe Domain::Demo::CleanIncompatibleDemos do
  let(:incompatible_demo) { demos(:record_demo) }
  let(:compatible_demo) { demos(:second_record_demo) }

  it 'sets the record fields' do
    Domain::Demo::CleanIncompatibleDemos.call(incompatible_demo.wad_id)
    incompatible_demo.reload.tic_record.must_equal(false)
    incompatible_demo.category_name.must_equal('Other')
    incompatible_demo.sub_categories.first.name.must_equal('Incompatible UV Speed')
    compatible_demo.reload.tic_record.must_equal(true)
    compatible_demo.category_name.must_equal('UV Speed')
  end
end
