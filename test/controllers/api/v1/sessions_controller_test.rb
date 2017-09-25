require 'test_helper'

class Api::V1::SessionsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:jo)
    @params = { email: @user.email, password: 'password' }
  end

  def login
    post api_v1_sessions_path, as: :json, params: @params
  end

  test "login returns created if valid credentials" do
    login
    assert_response :created
  end

  test "login returns access token if valid credentials" do
    login
    assert_match /"access_token":"[a-zA-Z0-9]*"/, @response.body
  end

  test "login returns json content if valid credentials" do
    login
    assert_equal 'application/json', @response.content_type
  end

  test "login returns bad request if password is incorrect" do
    @params[:password] = 'foobar'
    login
    assert_response :bad_request
  end

  test "login returns bad request if email does not exist" do
    @params[:email] = 'foo@bar.com'
    login
    assert_response :bad_request
  end

  test "login returns bad request if params is not set" do
    post api_v1_sessions_path, as: :json
    assert_response :bad_request
  end

  test "logout returns ok if token is valid" do
    delete api_v1_sessions_path, as: :json, headers: token_header(@user)
    assert_response :ok
  end

  test "logout returns unauthorized when token is invalid" do
    delete api_v1_sessions_path, as: :json
    assert_response :unauthorized
  end
end
