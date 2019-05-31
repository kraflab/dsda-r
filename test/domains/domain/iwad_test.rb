require 'test_helper'

describe Domain::Iwad do
  describe '.list' do
    it 'returns a list of iwads' do
      Domain::Iwad.list.first.must_be_instance_of Iwad
    end
  end

  describe '.single' do
    let(:iwad) { iwads(:doom) }

    it 'returns an iwad' do
      Domain::Iwad.single(short_name: iwad.short_name).must_equal iwad
    end

    describe 'when using either_name' do
      it 'returns an iwad' do
        Domain::Iwad.single(either_name: iwad.short_name).must_equal iwad
      end
    end

    describe 'when the iwad does not exist' do
      let(:single) {
        Domain::Iwad.single(short_name: 'not found', assert: assert_presence)
      }

      describe 'when asserting presence' do
        let(:assert_presence) { true }

        it 'raises error' do
          proc { single }.must_raise ActiveRecord::RecordNotFound
        end
      end

      describe 'when not asserting presence' do
        let(:assert_presence) { false }

        it 'returns nil' do
          single.must_be_nil
        end
      end
    end
  end
end
