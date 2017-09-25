module UsersHelper

  def create_user(email = 'foo@mail.com')
    get new_user_path
    assert_response :success

    assert_select 'form#new_user' do
      assert_select 'input#user_email'
      assert_select 'input[type=submit]'
    end

    assert_difference 'User.count' do
      post users_path, params: { user: { email: email } }
    end
    assert_response :redirect

    follow_redirect!
    assert_response :success

    assert_match /Email sent to <strong>#{email}<\/strong>/, @response.body
    assert_equal [email], last_email.to

    last_email.text_part.body.to_s.match(/Contraseña:\s([a-zA-Z0-9\-_]*)/)[1]
  end

end
