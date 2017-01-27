ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/reporters'
Minitest::Reporters.use!

class ActiveSupport::TestCase
  fixtures :all
  
  # Returns true if a test admin is logged in.
  def is_logged_in?
    !session[:username].nil?
  end
  
  # Logs in a test admin
  def log_in_as(admin, options = {})
    password = options[:password] || 'password1234'
    if integration_test?
      post login_path, params: { session: { username: admin.username,
                                            password: password } }
    else
      session[:username] = admin.username
    end
  end
  
  private
  
    # Returns true inside an integration test.
    def integration_test?
      defined?(post_via_redirect)
    end
end
