require "test_helper"

class Users::RegistrationsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = { email: "foo@bar.com",
              password: "password",
              password_confirmation: "password" }
  end

  def create_user
    post user_registration_path, params: { user: @user }
  end

  test "redirects to root after create" do
    create_user
    assert_redirected_to new_user_session_path
  end

  test "user is persisted as an amdin" do
    assert_difference "User.count" do
      create_user
    end

    user = User.find_by(email: @user[:email])
    assert user.admin?
  end

  test "creates company" do
    assert_difference "Company.count" do
      create_user
    end
  end

  test "does not create user and company if invalid user" do
    @user[:email] = ""
    assert_no_difference ["User.count", "Company.count"] do
      create_user
    end
  end

  test "redirects to root if logged in" do
    sign_in users(:jo)
    create_user
    assert_redirected_to dashboard_path
  end

  test "does not create user if logged in" do
    sign_in users(:jo)
    assert_no_difference "User.count" do
      create_user
    end
  end

  test "does not create company if logged in" do
    sign_in users(:jo)
    assert_no_difference "Company.count" do
      create_user
    end
  end

  test "does not create user and company if email already exists" do
    assert_no_difference ["User.count", "Company.count"] do
      @user[:email] = "jo@spectre.com"
      create_user
    end
  end
end
