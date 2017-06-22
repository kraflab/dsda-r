ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/reporters'
require 'capybara/rails'
require 'capybara/minitest'
Minitest::Reporters.use!
Capybara.javascript_driver = :selenium
Capybara.default_driver = :selenium

class CapybaraIntegrationTest < ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in these integration tests
  include Capybara::DSL
  # Make `assert_*` methods behave like Minitest assertions
  include Capybara::Minitest::Assertions

  # Reset sessions and driver between tests
  # Use super wherever this method is redefined in your individual test classes
  def teardown
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end

  def add_cookie(page, name, value)
    page.driver.browser.manage.add_cookie name: name, value: value
  end
end

class ActiveSupport::TestCase
  fixtures :all

  # Returns true if a test admin is logged in.
  def is_logged_in?
    !session[:username].nil?
  end

  # Returns a dummy zip for tests
  def dummy_zip(n = 0)
    File.open(Rails.root.join("test/fixtures/files/test#{n}.zip"))
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

  # get total time for thing's demos
  def total_demo_time(thing, with_tics = true)
    Demo.tics_to_string(thing.demos.sum(:tics), with_tics)
  end

  private

    # Returns true inside an integration test.
    def integration_test?
      defined?(post_via_redirect)
    end
end
