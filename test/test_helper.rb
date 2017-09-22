require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'devise'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  def make_params(options = {})
    ActionController::Parameters.new(options)
  end

  def last_email
    ActionMailer::Base.deliveries.last
  end

  def mailer_size
    ActionMailer::Base.deliveries.size
  end

  def reset_emails
    ActionMailer::Base.deliveries = []
  end

end

class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def token_header(user)
    { 'Authorization': "Token token=\"#{user.access_token}\"" }
  end

  def login(user, password)
    post new_user_session_path, params: { user: { email: user.email, password: password } }
    assert_response :redirect
    follow_redirect!
    assert_response :success
  end

  def sign(user, password = 'password')
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: password
    click_button 'Log in'
  end

end
