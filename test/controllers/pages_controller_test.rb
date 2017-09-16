require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest

  test "index redirects to dashboard if logged in" do
    sign_in users(:jo)
    get root_path
    assert_redirected_to dashboard_path
  end

  test "index returns success" do
    get root_path
    assert_response :success
  end

end
