require 'test_helper'

describe Service::Tics::ToString do
  describe 'when asked for cs' do
    it 'includes cs' do
      _(Service::Tics::ToString.call(111, with_cs: true)).must_equal '0:01.11'
    end
  end

  describe 'when not asked for cs' do
    it 'does not include cs' do
      _(Service::Tics::ToString.call(1234567, with_cs: false)).must_equal '3:25:45'
    end
  end
end
