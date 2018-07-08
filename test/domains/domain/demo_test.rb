require 'test_helper'

describe Domain::Demo do
  describe '.list' do
    it 'returns a list of demos' do
      Domain::Demo.list.first.must_be_instance_of Demo
    end
  end
end
