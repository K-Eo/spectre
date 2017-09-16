require "application_system_test_case"

class WorkersFlowTest < ApplicationSystemTestCase
  test "user adds new worker" do
    user = users(:jo)

    visit new_user_session_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'password'
    click_button 'Log in'

    visit workers_path

    fill_in 'worker_email', with: 'foo@bar.com'
    click_button 'Agregar trabajador'

    assert_text "Email sent to foo@bar.com."

    assert_text user.name, count: 1
    assert_no_text user.email
    assert_text 'foo@bar.com', count: 2

    assert_selector 'li[id^=worker_]', count: 1

    assert_equal ['foo@bar.com'], last_email.to
    assert_equal 'Credenciales para cuenta de Spectre', last_email.subject
  end
end
