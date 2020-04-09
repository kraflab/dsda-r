module JsonWebToken
  SECRET_KEY = Rails.application.secrets.secret_key_base
  EXPIRATION_TIME = 1.week

  class DecodeError < StandardError; end

  extend self

  def encode(admin)
    payload = {
      iss: 'dsda',
      aud: 'dsda',
      sub: admin.id.to_s,
      exp: EXPIRATION_TIME.from_now.to_i
    }
    JWT.encode(payload, SECRET_KEY)
  end

  def decode(token)
    JWT.decode(token, SECRET_KEY)[0].deep_symbolize_keys
  rescue JWT::DecodeError
    raise DecodeError
  end
end
