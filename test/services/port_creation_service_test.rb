require 'test_helper'

describe PortCreationService do
  let(:params) {
    {
      family: 'zdoom',
      version: 'v2.7',
      file: { data: '1234', name: 'zdoom.zip' }
    }
  }
  let(:service) { PortCreationService.new(params) }

  describe '#create!' do
    let(:create) { service.create! }

    describe 'when the params are valid' do
      it 'creates a port' do
        assert_difference 'Port.count', +1 do
          create
        end
      end

      it 'returns the port' do
        create.must_be_instance_of Port
      end
    end

    describe 'when the params are invalid' do
      let(:params) { { oops: 'nothing' } }

      it 'raises an error' do
        proc { create }.must_raise ActiveRecord::RecordInvalid
      end
    end
  end
end
