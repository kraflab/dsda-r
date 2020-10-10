ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/reporters'
require 'minitest/spec'
require 'capybara/rails'
require 'capybara/minitest'
require 'mocha/minitest'

Minitest::Reporters.use!
Capybara.javascript_driver = :selenium
Capybara.default_driver = :selenium
CarrierWave.root = 'test/fixtures/public'

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

  extend MiniTest::Spec::DSL

  register_spec_type self do |desc|
    true
  end

  # Returns a dummy zip for tests
  def dummy_zip(n = 0)
    File.open(Rails.root.join("test/fixtures/public/test#{n}.zip"))
  end

  # get total time for thing's demos
  def total_demo_time(thing, with_cs = true)
    Service::Tics::ToString.call(thing.demos.sum(:tics), with_cs: with_cs)
  end

  def setup_auth_headers(with_otp: false)
    @headers = {
      'Authorization' => "Bearer #{JsonWebToken.encode(@admin)}"
    }
    @wrong_headers = {
      'Authorization' => "Bearer bad-jwt"
    }

    @headers['OTP'] = otp_for(@admin) if with_otp

    return unless @unauthorized_admin

    @unauthorized_headers = {
      'Authorization' => "Bearer #{JsonWebToken.encode(@unauthorized_admin)}"
    }

    @unauthorized_headers['OTP'] = otp_for(@unauthorized_admin) if with_otp
  end

  private

  def integration_test?
    defined?(post_via_redirect)
  end

  def otp_for(object)
    raw_otp = OtpHandler.reset_otp!(object)
    ROTP::TOTP.new(raw_otp).now
  end
end
