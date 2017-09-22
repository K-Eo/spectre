require "application_system_test_case"

class UserRegistrationsTest < ApplicationSystemTestCase

  test "guest user creates new account" do
    visit root_path
    click_link 'Sign Up'
    fill_in 'Email', with: 'foo@bar.com'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    click_button 'Sign Up'

    assert_equal ['foo@bar.com'], last_email.to
  end

  test "does not create account and sends email if data is invalid" do
    visit root_path
    click_link 'Sign Up'
    fill_in 'Email', with: ''
    fill_in 'Password', with: ''
    fill_in 'Password confirmation', with: ''
    click_button 'Sign Up'

    assert_text "can't be blank", count: 2

    assert_nil last_email
  end

end
