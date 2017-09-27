require "test_helper"

class Api::V1::PasswordsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:jo)
  end

  def change_password(password, password_confirmation, current_password)
    params = { user: { password: password,
                       password_confirmation: password_confirmation,
                       current_password: current_password } }
    patch api_v1_password_path, params: params,
                                headers: token_header(@user)
  end

  test "returns ok if access token is valid" do
    change_password("foobar", "foobar", "password")
    assert_response :ok
  end

  test "returns unprocessable entity when password is empty" do
    change_password("", "foobar", "password")
    assert_response :unprocessable_entity
  end

  test "returns unprocessable entity when password confirmation is empty" do
    change_password("foobar", "", "password")
    assert_response :unprocessable_entity
  end

  test "returns unprocessable entity when current password is incorrect" do
    change_password("foobar", "foobar", "wrong password")
    assert_response :unprocessable_entity
  end
end
