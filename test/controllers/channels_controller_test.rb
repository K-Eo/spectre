require "test_helper"

class ChannelsControllerTest < ActionDispatch::IntegrationTest
  test "returns current user channels" do
    user = users(:jo)
    sign_in user
    get channels_path
    assert_response :ok
    assert_equal "application/json", @response.content_type
    assert_match /"private":"private-#{user.id}"/, @response.body
  end
end
