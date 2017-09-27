require "test_helper"

class DashboardsControllerTest < ActionDispatch::IntegrationTest
  test "index returns success" do
    sign_in users(:jo)
    get dashboard_path
    assert_response :success
  end

  test "index redirects to login if logged out" do
    get dashboard_path
    assert_redirected_to new_user_session_path
  end
end
