require "test_helper"

class Api::V1::ProfilesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:jo)
  end

  class Show < Api::V1::ProfilesControllerTest
    def nuke
      get api_v1_profile_path, headers: token_header(@user)
    end

    test "responds with ok if access token is valid" do
      nuke
      assert_response :ok
    end

    test "returns json content type if access token is valid" do
      nuke
      assert_equal "application/json", @response.content_type
    end

    test "returns user data as json if access token is valid" do
      nuke
      assert_match(/"email":"#{@user.email}"/, @response.body)
      assert_match(/"first_name":"#{@user.first_name}"/, @response.body)
      assert_match(/"last_name":"#{@user.last_name}"/, @response.body)
    end

    test "responds unauthorized if access token is invalid" do
      get api_v1_profile_path
      assert_response :unauthorized
    end
  end

  class Update < Api::V1::ProfilesControllerTest
    def nuke
      params = { profile: { first_name: "Carly", last_name: "Woods" } }
      patch api_v1_profile_path,
            params: params,
            headers: token_header(@user)
    end

    test "responds ok if access token is valid" do
      nuke
      assert_response :ok
    end

    test "returns updated user data if access token is valid" do
      nuke
      assert_match(/"first_name":"Carly"/, @response.body)
      assert_match(/"last_name":"Woods"/, @response.body)
    end

    test "responds bad request if no params and access token is valid" do
      patch api_v1_profile_path, headers: token_header(@user)
      assert_response :bad_request
    end

    test "responds unauthorized if access token is invalid" do
      patch api_v1_profile_path
      assert_response :unauthorized
    end
  end
end
