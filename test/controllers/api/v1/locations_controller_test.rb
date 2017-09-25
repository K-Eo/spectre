require 'test_helper'

class Api::V1::LocationsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:jo)
  end

  class Show < Api::V1::LocationsControllerTest

    def nuke
      get api_v1_location_path, headers: token_header(@user)
    end

    test "responds with ok if access token is valid" do
      nuke
      assert_response :ok
    end

    test "returns json contet type if access token is valid" do
      nuke
      assert_equal 'application/json', @response.content_type
    end

    test "returns user location as json if access token is valid" do
      nuke
      assert_match /"lat":#{@user.lat}/, @response.body
      assert_match /"lng":#{@user.lng}/, @response.body
    end

    test "responds unauthorized if access token is invalid" do
      get api_v1_location_path
      assert_response :unauthorized
    end
  end

  class Update < Api::V1::LocationsControllerTest

    def setup
      super
      @params = { location: { lat: 60, lng: -90 } }
    end

    def nuke
      patch api_v1_location_path, params: @params, headers: token_header(@user)
    end

    test "responds with ok if access token is valid" do
      nuke
      assert_response :ok
    end

    test "returns updated location as json" do
      nuke
      assert_match /"lat":#{60}/, @response.body
      assert_match /"lng":#{-90}/, @response.body
    end

    test "updates user location" do
      nuke
      @user.reload
      assert_equal 60, @user.lat
      assert_equal -90, @user.lng
    end

    test "responds with unprocessable if no params" do
      @params = nil
      nuke
      assert_response :bad_request
    end

    test "responds with unauthorized if access token is invalid" do
      patch api_v1_location_path
      assert_response :unauthorized
    end
  end
end
