require "test_helper"

class SignUpTest < ActionDispatch::IntegrationTest
  test "guest user signs up" do
    guest_sign_up
  end
end
