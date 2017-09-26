require 'test_helper'

class ChangeUserEmailTest < ActionDispatch::IntegrationTest

  test "user can change his email" do
    user = users(:jo)
    sign_in(user)

    get user_path(user)
    assert_response :success

    assert_select 'h5', 'Cambiar correo electrónico'
    assert_select "form#edit_email_#{user.id}" do
      assert_select "input#email_email[value='#{user.email}']"
      assert_select "input#email_current_password"
      assert_select "input[type=submit]"
    end

    patch email_path(user),
          params: { email: { email: 'foo@bar.com', current_password: 'password' } }

    assert_redirected_to user_path(user)
    follow_redirect!
    assert_response :success

    assert_match /Recibirá un correo con instrucciones para confirmar/, @response.body

    assert_equal ['foo@bar.com'], last_email.to
    assert_match /You can confirm your account/, last_email.body.to_s

    token = last_email.body.to_s.match(/confirmation_token=[a-zA-Z0-9\-_]*/)

    sign_out(user)

    guest_confirmation(token)
    user_login

    user.reload
    assert_equal 'foo@bar.com', user.email
  end
end
