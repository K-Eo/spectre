require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :chrome, screen_size: [1400, 1400], options: {
    browser: :remote,
    desired_capabilities: :chrome
  }

  def login_as(user, password = "password")
    email = user.respond_to?(:email) ? user.email : user

    visit new_user_session_path
    fill_in "Email", with: email
    fill_in "Password", with: password
    click_button "Log in"
  end
end
