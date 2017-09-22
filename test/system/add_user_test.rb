require "application_system_test_case"

class AddUserTest < ApplicationSystemTestCase
  test "user adds new user to company" do
    user = users(:eo)
    sign(user)

    visit new_user_path

    fill_in 'user_email', with: 'foo@bar.com'
    click_button 'Agregar Usuario'

    assert_text "Email sent to foo@bar.com."
    assert_text user.name, count: 1
    assert_no_text user.email
    assert_text 'foo@bar.com', count: 1

    assert_equal ['foo@bar.com'], last_email.to
    assert_equal 'Credenciales para cuenta de Spectre', last_email.subject
  end
end
