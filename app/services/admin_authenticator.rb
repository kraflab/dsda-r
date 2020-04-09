class AdminAuthenticator
  def initialize(request)
    @request = request
  end

  def authenticate!
    extract_credentials_from_request
    raise Errors::Unauthorized unless admin
    admin
  end

  private

  def admin
    @admin ||= @jwt ? authenticate_via_jwt : authenticate_via_password
  end

  # deprecated
  def authenticate_via_password
    admin = Admin.find_by(username: @username)
    return nil unless admin
    admin.try_authenticate(@password)
  end

  def authenticate_via_jwt
    Admin.find_by(id: id_from_jwt)
  rescue JsonWebToken::DecodeError
    nil
  end

  def id_from_jwt
    JsonWebToken.decode(@jwt)[:sub].to_i
  end

  def extract_credentials_from_request
    # deprecated
    @username = @request.headers['HTTP_API_USERNAME']
    @password = @request.headers['HTTP_API_PASSWORD']

    # future
    @jwt = @request.headers['Authorization']&.split(' ')&.last
  end
end
