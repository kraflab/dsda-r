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
      Domain::Iwad.single(short_name: iwad.username).must_equal iwad
    end
  end
end
