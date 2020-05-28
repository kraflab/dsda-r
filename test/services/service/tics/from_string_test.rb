require 'test_helper'

describe Service::Tics::FromString do
  describe 'when including cs' do
    it 'returns tics and true' do
      _(Service::Tics::FromString.call('0:01.11')).must_equal [111, true]
    end
  end

  describe 'when not including cs' do
    it 'returns tics and false' do
      _(Service::Tics::FromString.call('3:25:45')).must_equal [1234500, false]
    end
  end
end
