require 'test_helper'

describe Domain::Demo::UpdateRecordFields do
  let(:record_demo) { demos(:record_demo) }
  let(:second_record_demo) { demos(:second_record_demo) }
  let(:non_record_demo) { demos(:non_record_demo) }

  def record_fields(demo)
    [demo.tic_record, demo.second_record]
  end

  before do
    non_record_demo.update(tic_record: true, second_record: true)
  end

  it 'sets the record fields' do
    Domain::Demo::UpdateRecordFields.call(non_record_demo)
    record_fields(record_demo.reload).must_equal([true, false])
    record_fields(second_record_demo.reload).must_equal([false, true])
    record_fields(non_record_demo.reload).must_equal([false, false])
  end
end
