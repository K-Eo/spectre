require 'test_helper'

class Sandbox::DeviceControllerTest < ActionDispatch::IntegrationTest

  test "should get index" do
    get sandbox_devices_path
    assert_response :success
  end

end
