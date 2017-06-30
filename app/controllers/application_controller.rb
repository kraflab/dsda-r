class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  include ApplicationHelper
  include DemosHelper
  include WadsHelper
  ADMIN_ERR_LOCK = 3
  ADMIN_ERR_FAIL = 2
  ADMIN_SUCCESS  = 1

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

  # return the 3 most active wads of the past n demos
  def active_wads(n)
    Hash[Demo.where(id: Demo.recent(n)).group(:wad_id).count.
      sort_by { |k, v| -v }[0..2]]
  end

  # return the 3 most active players of the past n demos
  def active_players(n)
    Hash[DemoPlayer.includes(:demo).
      where('demos.id IN (?)', Demo.recent(n).select(:id)).
      references(:demo).group(:player_id).count.sort_by { |k, v| -v }[0..2]]
  end
end
