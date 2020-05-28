require 'test_helper'

describe AdminAuthorizer do
  describe '.authorize!' do
    let(:authorize) { AdminAuthorizer.authorize!(admin, :update) }

    describe 'when the admin is authorized' do
      let(:admin) { admins(:elim) }

      it 'succeeds' do
        _(authorize).must_equal true
      end
    end

    describe 'when the admin is not authorized' do
      let(:admin) { admins(:bob) }

      it 'raises an error' do
        _(proc { authorize }).must_raise Errors::Unauthorized
      end
    end
  end
end
