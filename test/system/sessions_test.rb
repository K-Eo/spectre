require "application_system_test_case"

class SessionsTest < ApplicationSystemTestCase
  test "user can login" do
    user = users(:eo)
    login_as(user)
    assert_text "Spectre Inc."
  end
end
