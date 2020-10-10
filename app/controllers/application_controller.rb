class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  include ApplicationHelper
  include DemosHelper
  include WadsHelper
  include PlayersHelper
  include Errors::RescueError

  def authenticate_admin!
    @current_admin = AdminAuthenticator.new(request).authenticate!
  end

  def verify_otp!
    OtpHandler.verify!(@current_admin, request.headers['OTP'])
  end

  def preprocess_api_request(options)
    @request_hash = ApiRequestParser.new(options.merge(request: request)).parse_json
  end
end
