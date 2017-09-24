require 'test_helper'

class ConfirmationTest < ActionDispatch::IntegrationTest

  test "guest confirmes email" do
    confirmation_token = guest_sign_up
    guest_confirmation(confirmation_token)
  end
end
