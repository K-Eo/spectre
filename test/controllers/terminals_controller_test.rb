require 'test_helper'

class TerminalsControllerTest < ActionDispatch::IntegrationTest

  test "should get index" do
    get terminals_path
    assert_response :success
  end

  test "should get new" do
    get terminals_path
    assert_response :success
  end

  test "should post create" do
    assert_difference 'Terminal.count' do
      post terminals_path, params: { terminal: { name: 'foobar' } }
      assert_redirected_to terminals_path
    end
  end

end
