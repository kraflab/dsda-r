module OtpHandler
  SECRET_KEY = Rails.application.secrets.secret_key_base

  extend self

  class Invalid < StandardError; end

  def reset_otp!(object)
    raw_otp = ROTP::Base32.random
    stored_otp = crypt.encrypt_and_sign(raw_otp)
    object.update!(otp: stored_otp, last_otp_at: Time.now.to_i)
    raw_otp
  end

  def verify!(object, value)
    raise Invalid unless object.otp

    raw_otp = crypt.decrypt_and_verify(object.otp)
    totp = ROTP::TOTP.new(raw_otp, issuer: 'dsda')

    result = totp.verify(value, after: object.last_otp_at, drift_behind: 15)
    raise Invalid unless result

    object.update!(last_otp_at: Time.now.to_i)
  end

  private

  def crypt
    @crypt ||= ActiveSupport::MessageEncryptor.new(SECRET_KEY[0..31])
  end
end
