require "test_helper"

class AddUserTest < ActionDispatch::IntegrationTest
  test "admin adds new user to company" do
    user = users(:eo)
    sign_in(user)
    create_user("foo@bar.com")
  end
end
