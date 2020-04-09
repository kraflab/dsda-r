class TokensController < ApplicationController
  EXPIRATION_TIME = 1.week

  def api_create
    raise Errors::Unauthorized unless admin

    render json: { token: token, exp: expiration_time }, status: :created
  end

  private

  def admin
    @admin ||= Admin.find_by(
      username: params[:username]
    )&.try_authenticate(params[:password])
  end

  def token
    JsonWebToken.encode(admin, exp: expiration_time)
  end

  def expiration_time
    @expiration_time ||= EXPIRATION_TIME.from_now.to_i
  end
end
