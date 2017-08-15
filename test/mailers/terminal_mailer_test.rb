require 'test_helper'

class TerminalMailerTest < ActionMailer::TestCase

  test "send pairing token" do
    email = TerminalMailer.pairing_token('user@example.com', '1234567890')

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ['spectre@support.com'], email.from
    assert_equal ['user@example.com'], email.to
    assert_equal 'Instrucciones para asociar dispositivo', email.subject
  end
end
