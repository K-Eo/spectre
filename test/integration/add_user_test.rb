require 'test_helper'

class AddUserTest < ActionDispatch::IntegrationTest

  test "admin adds new user to company" do
    user = users(:eo)
    sign_in(user)

    get new_user_path
    assert_response :success

    assert_select 'form#new_user' do
      assert_select 'input#user_email'
      assert_select 'input[type=submit]'
    end

    post users_path, params: { user: { email: 'foo@bar.com' } }
    assert_response :redirect

    follow_redirect!
    assert_response :success

    assert_match /Email sent to <strong>foo@bar.com<\/strong>/, @response.body
    assert_equal ['foo@bar.com'], last_email.to

    assert_select 'h5', 'Perfil'
    assert_select 'h5', 'Geolocalización'
  end

end
