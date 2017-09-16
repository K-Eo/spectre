require 'test_helper'

class Api::V1::UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:jo)
  end

  class GetUserInfo < Api::V1::UsersControllerTest

    test "responds with ok if access token is valid" do
      get api_v1_user_path, as: :json, headers: token_header(@user)
      assert_response :ok
    end

    test "returns json in content type if access token is valid" do
      get api_v1_user_path, as: :json, headers: token_header(@user)
      assert_equal 'application/json', @response.content_type
    end

    test "returns json object if access token is valid" do
      get api_v1_user_path, as: :json, headers: token_header(@user)
      assert_match /"email":"#{@user.email}"/, @response.body
      assert_match /"first_name":"#{@user.first_name}"/, @response.body
      assert_match /"last_name":"#{@user.last_name}"/, @response.body
    end

    test "responds with unauthorized if access token is invalid" do
      get api_v1_user_path, as: :json
      assert_response :unauthorized
    end

  end

  class UpdateUser < Api::V1::UsersControllerTest

    test "returns ok if access token is valid" do
      params = { profile: { first_name: 'Carly', last_name: 'Woods' } }
      patch api_v1_user_path, params: params, as: :json, headers: token_header(@user)
      assert_response :ok
    end

    test "returns new json if access token is valid" do
      params = { profile: { first_name: 'Carly', last_name: 'Woods' } }
      patch api_v1_user_path, params: params, as: :json, headers: token_header(@user)
      assert_match /"first_name":"Carly"/, @response.body
      assert_match /"last_name":"Woods"/, @response.body
    end

    test "responds unprocessable entity if no params and access token is valid" do
      patch api_v1_user_path, as: :json, headers: token_header(@user)
      assert_response :unprocessable_entity
    end

    test "respondes with unauthorized if access token is invalid" do
      patch api_v1_user_path, as: :json
      assert_response :unauthorized
    end

  end

  class UpdatePassword < Api::V1::UsersControllerTest

    def change_password(password, password_confirmation, current_password)
      params = { user: { password: password,
                         password_confirmation: password_confirmation,
                         current_password: current_password } }
      patch update_password_api_v1_user_path, as: :json,
                                              params: params,
                                              headers: token_header(@user)
    end

    test "returns ok if access token is valid" do
      change_password('foobar', 'foobar', 'password')
      assert_response :ok
    end

    test "returns unprocessable entity when password is empty" do
      change_password('', 'foobar', 'password')
      assert_response :unprocessable_entity
    end

    test "returns unprocessable entity when password confirmation is empty" do
      change_password('foobar', '', 'password')
      assert_response :unprocessable_entity
    end

    test "returns unprocessable entity when current password is incorrect" do
      change_password('foobar', 'foobar', 'wrong password')
      assert_response :unprocessable_entity
    end

  end

end
