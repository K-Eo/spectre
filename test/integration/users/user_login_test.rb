require 'test_helper'

class UserLoginTest < ActionDispatch::IntegrationTest

  test "user logins with credentials sent on email" do
    user = users(:eo)
    sign_in(user)
    password = create_user
    sign_out(user)

    post user_session_path,
         params: { user: { email: 'foo@mail.com', password: password } }
    assert_redirected_to dashboard_path
    follow_redirect!
    assert_response :success

    assert_match /Spectre Inc./, @response.body
  end
end
