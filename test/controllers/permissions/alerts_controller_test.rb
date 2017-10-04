require "test_helper"

class Permissions::AlertsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:eo)
  end

  test "sets monitor to true" do
    patch user_permissions_alert_path(@user), xhr: true
    assert_response :ok
  end
end
