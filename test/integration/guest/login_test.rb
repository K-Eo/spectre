require 'test_helper'

class LoginTest < ActionDispatch::IntegrationTest

  test "guest logins" do
    confirmation_token = guest_sign_up
    guest_confirmation(confirmation_token)
    guest_login
  end
end
