module GuestHelper

  def guest_sign_up
    get new_user_registration_path
    assert_response :success

    assert_select 'form#new_user' do
      assert_select 'input#user_email'
      assert_select 'input#user_password'
      assert_select 'input#user_password_confirmation'
      assert_select 'input[type=submit]'
    end

    assert_difference ['User.count', 'Company.count'] do
      post user_registration_path,
           params: { user: { email: 'foo@bar.com',
                             password: 'password',
                             password_confirmation: 'password' } }
    end

    assert_redirected_to new_user_session_path
    follow_redirect!
    assert_response :success
    assert_match /A message with a confirmation/, @response.body

    assert_equal ['foo@bar.com'], last_email.to
    last_email.body.to_s.match(/confirmation_token=[a-zA-Z0-9\-_]*/)
  end

  def guest_confirmation(confirmation_token)
    get "/auth/confirmation?#{confirmation_token}"

    assert_redirected_to new_user_session_path
    follow_redirect!
    assert_response :success
    assert_match /successfully confirmed/, @response.body

    assert_select 'form#new_user' do
      assert_select 'input#user_email'
      assert_select 'input#user_password'
      assert_select 'input#user_remember_me'
      assert_select 'input[type=submit]'
    end
  end

  def user_login(email = 'foo@bar.com', password = 'password')
    post user_session_path,
         params: { user: { email: email, password: password } }
    assert_redirected_to dashboard_path
    follow_redirect!
    assert_response :success
  end

  def guest_login
    user_login
    assert_match /My Company/, @response.body
  end
end
