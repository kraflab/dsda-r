class AuthToken
  class << self
    def key
      Rails.application.secrets.secret_key_base
    end

    def token(user)
      payload = {
        user_id: user.id,
        exp: expiration_time
      }
      JWT.encode(payload, key)
    end

    def decode(token)
      JWT.decode(token, key).first
    rescue JWT::ExpiredSignature
      { error: 'expired signature' }
    rescue JWT::VerificationError
      { error: 'verification error' }
    rescue JWT::DecodeError
      { error: 'decode error' }
    end

    def user_from_token(token)
      result = decode(token)
      return nil if result[:error]
      User.find_by(id: result['user_id'])
    end

    EXPIRATION_TIME = 2.hours

    def expiration_time
      (Time.now + EXPIRATION_TIME).to_i
    end
  end
end
