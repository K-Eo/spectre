require 'test_helper'

class ChangeUserPasswordTest < ActionDispatch::IntegrationTest

  test "user can change his passsword" do
    user = users(:jo)
    sign_in(user)

    get user_path(user)
    assert_response :success

    assert_select 'h5', 'Cambiar contraseña'
    assert_select "form#edit_password_#{user.id}" do
      assert_select "input#password_password"
      assert_select "input#password_password_confirmation"
      assert_select "input#password_current_password"
    end

    patch password_path(user),
          params: { password: { password: 'foobar',
                                password_confirmation: 'foobar',
                                current_password: 'password' } }
    assert_redirected_to user_path(user)
    follow_redirect!
    assert_response :success

    assert_match /Su contraseña ha sido actualizada/, @response.body

    sign_out(user)

    user_login(user.email, 'foobar')
  end
end
