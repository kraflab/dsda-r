module SessionsHelper
  
  # Logs in the given admin
  def log_in(admin)
    session[:username] = admin.username
    admin.fail_count = 0
    admin.save
  end
  
  # Logs out the current admin
  def log_out
    session.delete(:username)
    @current_admin = nil
  end
  
  # Returns the current logged-in admin (if any)
  def current_admin
    @current_admin ||= Admin.find_by(username: session[:username])
  end
  
  # Returns true if this is an admin session
  def logged_in?
    !current_admin.nil?
  end
  
  # Returns array of category filters
  def category_filter_array
    JSON.parse(cookies["category_filter"])
  end
  
  # DRY delete pattern
  def delete_me(object)
    link_to "Delete", object, method: :delete,
    data: { confirm: "Are you sure?" }, :class => "label label-danger"
  end
end
