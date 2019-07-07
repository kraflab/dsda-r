require 'test_helper'

describe Domain::Demo::UpdateRecordFields do
  let(:record_demo) { demos(:record_demo) }
  let(:second_record_demo) { demos(:second_record_demo) }
  let(:non_record_demo) { demos(:non_record_demo) }

  def record_fields(demo)
    [demo.tic_record, demo.second_record, demo.record_index]
  end

  before do
    non_record_demo.update(
      tic_record: true, second_record: true, record_index: 2
    )
  end

  it 'sets the record fields' do
    Domain::Demo::UpdateRecordFields.call(non_record_demo)
    record_fields(record_demo.reload).must_equal([true, false, 2])
    record_fields(second_record_demo.reload).must_equal([false, true, 0])
    record_fields(non_record_demo.reload).must_equal([false, false, 0])
  end

  describe 'when a pacifist record beats the speed' do
    before do
      record_demo.update(category_id: 3) # Pacifist
    end

    it 'sets the record fields' do
      Domain::Demo::UpdateRecordFields.call(non_record_demo)
      # This one is false / false because it is the only pacifist
      record_fields(record_demo.reload).must_equal([false, false, 2])
      record_fields(second_record_demo.reload).must_equal([false, true, 0])
      record_fields(non_record_demo.reload).must_equal([false, false, 0])
    end
  end
end
