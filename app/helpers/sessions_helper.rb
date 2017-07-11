module SessionsHelper

  # Returns the current logged-in admin (if any)
  def current_admin
    @current_admin ||= Admin.find_by(username: session[:username])
  end

  # Returns true if this is an admin session
  # Admin functionality is currently suppressed, except where explicitly forced
  def logged_in?(force_answer = false)
    force_answer ? !current_admin.nil? : false
  end

  # Returns array of demo filters
  def demo_filter_array
    JSON.parse(cookies['demo_filter'])
  end
end
