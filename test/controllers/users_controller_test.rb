require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  class Index < UsersControllerTest

    test "index returns success" do
      sign_in users(:eo)
      get users_path
      assert_response :success
    end

    test "index redirects to login if logged out" do
      get users_path
      assert_redirected_to new_user_session_path
    end

  end

  class Create < UsersControllerTest

    def create_user(auth = true, email = 'foo@bar.com')
      sign_in(users(:jo)) if auth
      params = { user: { email: email } }
      post users_path, params: params
    end

    test "responds with created if user data is valid" do
      create_user
      assert_response :redirect
    end

    test "sets flash if user data is valid" do
      create_user
      assert_match /Email sent to/, flash[:success]
    end

    test "renders error if email is invalid" do
      create_user(true, '')
      assert_match /is invalid/, @response.body
    end

    test "responds with unprocessable entity if email is invalid" do
      create_user(true, '')
      assert_response :unprocessable_entity
    end

    test "responds with bad request if user param is blank" do
      sign_in users(:jo)
      post users_path
      assert_response :bad_request
    end

    test "sets flash if user param is blank" do
      sign_in users(:jo)
      post users_path
      assert_match /Email required/, flash[:alert]
    end

    test "redirects to login if logged out" do
      create_user(false)
      assert_redirected_to new_user_session_path
    end

  end

end
