require 'test_helper'

describe OtpHandler do
  let(:admin) { admins(:elim) }

  describe '.reset_otp!' do
    it 'sets a new otp' do
      assert_nil admin.otp
      OtpHandler.reset_otp!(admin)
      assert admin.otp
    end
  end

  describe '.verify!' do
    describe 'when the value is correct' do
      it 'updates the last use time' do
        raw_otp = OtpHandler.reset_otp!(admin)
        totp = ROTP::TOTP.new(raw_otp, issuer: 'dsda')

        Timecop.freeze(1.minute.from_now) do
          value = totp.now

          assert OtpHandler.verify!(admin, value)
          assert admin.last_otp_at == Time.now.to_i
        end
      end

      describe 'when it is reused' do
        it 'raises an error' do
          raw_otp = OtpHandler.reset_otp!(admin)
          totp = ROTP::TOTP.new(raw_otp, issuer: 'dsda')

          Timecop.freeze(1.minute.from_now) do
            value = totp.now

            OtpHandler.verify!(admin, value)
            _(proc { OtpHandler.verify!(admin, value) }).must_raise OtpHandler::Invalid
          end
        end
      end
    end

    describe 'when the value is wrong' do
      it 'raises an error' do
        OtpHandler.reset_otp!(admin)

        Timecop.freeze(1.minute.from_now) do
          value = "111111"

          _(proc { OtpHandler.verify!(admin, value) }).must_raise OtpHandler::Invalid
        end
      end
    end
  end
end
