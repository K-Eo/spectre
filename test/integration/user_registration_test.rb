require 'test_helper'

class UserRegistrationTest < ActionDispatch::IntegrationTest

  test "guest user creates new account" do
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
    assert_match /A message with a confirmation/, @response.body

    assert_equal ['foo@bar.com'], last_email.to
  end

  test "renders error if data is invalid" do
    get new_user_session_path
    assert_response :success

    assert_no_difference ['User.count', 'Company.count'] do
      post user_registration_path,
           params: { user: { email: '',
                             password: '',
                             password_confirmation: '' } }
    end
    assert_response :success

    assert_select '.invalid-feedback', 2
    assert_nil last_email
  end

end
