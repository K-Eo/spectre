require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

module ApiHelper
  def token_header(user)
    { 'Authorization': "Token token=\"#{user.access_token}\"" }
  end
end

class ActionDispatch::IntegrationTest
  include ApiHelper
end
