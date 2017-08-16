require 'test_helper'

class Sandbox::DeviceControllerTest < ActionDispatch::IntegrationTest
  test "should get pairing" do
    get sandbox_device_pairing_url
    assert_response :success
  end

end
