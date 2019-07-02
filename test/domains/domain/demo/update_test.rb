require 'test_helper'

describe Domain::Demo::Update do
  let(:demo) { Demo.new }
  let(:old_recorded_at) { '2019-07-02'.to_datetime }
  let(:new_recorded_at) { old_recorded_at }
  let(:update) do
    Domain::Demo::Update.call(demo, recorded_at: new_recorded_at)
  end
  let(:old_attributes) do
    { year: old_recorded_at.year, recorded_at: old_recorded_at }
  end
  let(:new_attributes) do
    { year: new_recorded_at.year, recorded_at: new_recorded_at }
  end

  before do
    Domain::Demo::Save.stubs(:call)
    demo.stubs(:attributes).returns(old_attributes).then.returns(new_attributes)
  end

  it 'assigns the attributes' do
    update
    demo.recorded_at.must_equal(new_recorded_at)
  end

  it 'saves the demo' do
    Domain::Demo::Save.expects(:call).with(demo)
    update
  end

  describe 'year updates' do
    before do
      DemoYear.create(year: new_recorded_at.year, count: 1)
      DemoYear.create(year: old_recorded_at.year, count: 1)
    end

    describe 'when the year changed' do
      let(:new_recorded_at) { old_recorded_at + 1.year }

      it 'updates the demo year cache' do
        update
        DemoYear.find_by(year: old_recorded_at.year).count.must_equal(0)
        DemoYear.find_by(year: new_recorded_at.year).count.must_equal(2)
      end
    end

    describe 'when the year did not change' do
      let(:new_recorded_at) { old_recorded_at }

      it 'does nothing' do
        assert_no_difference 'DemoYear.find_by(year: old_recorded_at.year).count' do
          update
        end
      end
    end
  end
end
