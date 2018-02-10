class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  include ApplicationHelper
  include DemosHelper
  include WadsHelper
  include PlayersHelper
  ADMIN_FAIL_LIMIT = 5
  ADMIN_ERR_LOCK = 3
  ADMIN_ERR_FAIL = 2
  ADMIN_SUCCESS  = 1

  def authenticate_admin!
    username = request.headers["HTTP_API_USERNAME"]
    password = request.headers["HTTP_API_PASSWORD"]
    @current_admin = authenticate_admin_via_password(username, password)
    raise Errors::Unauthorized if @current_admin.nil?
  end

  def authenticate_admin_via_password(username, password)
    admin = Admin.find_by(username: username)
    return nil if admin.nil? || admin.fail_count >= ADMIN_FAIL_LIMIT
    return admin if admin.authenticate(password)
    admin.update(fail_count: admin.fail_count + 1)
    return nil
  end

  # Process admin login credentials
  def authenticate_admin(username, password)
    admin = Admin.find_by(username: username)
    if admin
      if admin.fail_count >= 5
        [admin, ADMIN_ERR_LOCK]
      elsif admin.authenticate(password)
        [admin, ADMIN_SUCCESS]
      else
        admin.reload.fail_count += 1
        admin.save
        [admin, ADMIN_ERR_FAIL]
      end
    else
      [nil, nil]
    end
  end

  # Basic pass for api
  def preprocess_api(request, require_query = true)
    response_hash = {}
    response_hash[:error_message] = []
    query = JSON.parse(request.body.read)
    if require_query and query.nil?
      response_hash[:error_message].push 'No command given'
    end

    [query, response_hash]
  end

  # Preprocess api with authentication
  def preprocess_api_authenticate(request, require_query = true)
    query, response_hash = preprocess_api(request, require_query)
    admin, code = authenticate_admin(request.headers["HTTP_API_USERNAME"],
                                     request.headers["HTTP_API_PASSWORD"])
    if admin
      case code
      when ADMIN_SUCCESS
        authenticated_admin = admin
      when ADMIN_ERR_LOCK
        response_hash[:error_message].push 'This account has been locked; contact kraflab'
      else
        response_hash[:error_message].push 'Invalid username/password combination'
      end
    else
      response_hash[:error_message].push 'Invalid username/password combination'
    end

    [query, response_hash, authenticated_admin]
  end

  # Basic api check for file data
  def has_file_data?(query)
    query['file'] and query['file']['data'] and query['file']['name']
  end

  def preprocess_api_request(*required_fields)
    @request_hash = JSON.parse(request.body.read).deep_symbolize_keys
    raise Errors::UnprocessableEntity, 'missing required fields' unless required_keys.all? { |k| @request_body.key? k }
  end
end
