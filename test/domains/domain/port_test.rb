require 'test_helper'

describe Domain::Port do
  describe '.create' do
    it 'delegates port creation' do
      Domain::Port::Create.expects(:call)
      Domain::Port.create
    end
  end

  describe '.list' do
    it 'returns a list of ports' do
      _(Domain::Port.list.first).must_be_instance_of Port
    end
  end
end
