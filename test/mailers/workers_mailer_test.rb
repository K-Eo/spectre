require "test_helper"

class WorkersMailerTest < ActionMailer::TestCase
  test "credentials" do
    email = WorkersMailer.credentials("foo@bar.com", "worker_password")

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ["foo@bar.com"], email.to
    assert_equal ["spectre@support.com"], email.from
    assert_equal "Credenciales para cuenta de Spectre", email.subject

    assert_match(/foo@bar.com/, email.text_part.body.to_s)
    assert_match(/foo@bar.com/, email.html_part.body.to_s)

    assert_match(/worker_password/, email.text_part.body.to_s)
    assert_match(/worker_password/, email.html_part.body.to_s)
  end
end
