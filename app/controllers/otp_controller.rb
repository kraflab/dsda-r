class OtpController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_admin!

  def reset
    AdminAuthorizer.authorize!(@current_admin, :create)

    if @current_admin.otp.present?
      render json: { errors: 'You can only set an otp once.' }, status: 422
    else
      raw_otp = OtpHandler.reset_otp!(@current_admin)
      render json: { otp: raw_otp }
    end
  end
end
