require 'test_helper'

class Api::V1::AlertsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:jo)
    @params = { alert: { text: 'foobar' } }
  end

  test "create new alert responds with created if logged in" do
    post api_v1_alerts_path, params: @params, headers: token_header(@user)
    assert_response :created
  end

  test "creates alert if text is empty" do
    @params[:alert][:text] = ''
    post api_v1_alerts_path, params: @params, headers: token_header(@user)
    assert_response :created
  end

  test "create alert responds with 201 if params is not set" do
    post api_v1_alerts_path, headers: token_header(@user)
    assert_response :bad_request
  end

  test "create new alert responds with unauthorized if logged out" do
    post api_v1_alerts_path, params: @params
    assert_response :unauthorized
  end

end
