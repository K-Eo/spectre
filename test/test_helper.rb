require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "devise"
require "support/users_helper"
require "support/mailer_helper"
require "support/guest_helper"

module ActiveSupport
  class TestCase
    fixtures :all
    include MailerHelper

    def make_params(options = {})
      ActionController::Parameters.new(options)
    end
  end
end

# TODO: Check namespace for integration tests
module ActionDispatch
  class IntegrationTest
    include Devise::Test::IntegrationHelpers
    include UsersHelper
    include GuestHelper

    def token_header(user)
      headers = {}
      headers["Authorization"] = "Token token=\"#{user.access_token}\""
      headers
    end
  end
end
