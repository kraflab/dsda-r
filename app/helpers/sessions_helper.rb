module SessionsHelper

  # Returns the current logged-in admin (if any)
  def current_admin
    @current_admin ||= Admin.find_by(username: session[:username])
  end

  # Returns true if this is an admin session
  def logged_in?
    !current_admin.nil?
  end

  # Returns array of demo filters
  def demo_filter_array
    JSON.parse(cookies['demo_filter'])
  end
end
