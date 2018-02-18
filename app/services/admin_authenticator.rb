class AdminAuthenticator
  def initialize(request)
    @request = request
  end

  def authenticate!
    extract_credentials_from_request
    admin = authenticate_via_password
    raise Errors::Unauthorized unless admin
    admin
  end

  private

  def authenticate_via_password
    admin = Admin.find_by(username: @username)
    return nil unless admin
    admin.try_authenticate(@password)
  end

  def extract_credentials_from_request
    @username = @request.headers['HTTP_API_USERNAME']
    @password = @request.headers['HTTP_API_PASSWORD']
  end
end
