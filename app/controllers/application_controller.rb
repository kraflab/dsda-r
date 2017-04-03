class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  include ApplicationHelper
  include DemosHelper
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
end
