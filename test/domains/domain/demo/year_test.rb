require 'test_helper'

describe Domain::Demo::Year do
  let(:now) { '2019-07-02'.to_datetime }
  let(:last_year) { now - 1.year }

  describe '.increment' do
    def increment(datetime)
      Domain::Demo::Year.increment(datetime)
    end

    it 'increments the count' do
      increment(now)
      DemoYear.find_by(year: now.year).count.must_equal(1)
      increment(now)
      DemoYear.find_by(year: now.year).count.must_equal(2)
    end

    it 'does not increment other years' do
      increment(last_year)
      assert_nil DemoYear.find_by(year: now.year)
    end

    describe 'when given nil' do
      it 'does nothing' do
        assert_no_difference 'DemoYear.count' do
          increment(nil)
        end
      end
    end
  end

  describe '.decrement' do
    def decrement(datetime)
      Domain::Demo::Year.decrement(datetime)
    end

    before do
      DemoYear.create(year: now.year, count: 4)
    end

    it 'decrements the count' do
      decrement(now)
      DemoYear.find_by(year: now.year).count.must_equal(3)
      decrement(now)
      DemoYear.find_by(year: now.year).count.must_equal(2)
    end

    it 'does not decrement other years' do
      decrement(last_year)
      DemoYear.find_by(year: now.year).count.must_equal(4)
    end

    describe 'when given nil' do
      it 'does nothing' do
        assert_no_difference 'DemoYear.count' do
          decrement(nil)
        end
      end
    end
  end
end
