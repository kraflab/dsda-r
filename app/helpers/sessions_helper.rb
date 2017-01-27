module SessionsHelper
  
  # Logs in the given admin
  def log_in(admin)
    session[:username] = admin.username
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
end
