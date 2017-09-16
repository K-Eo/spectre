require 'test_helper'

class WorkersFlowTest < ActionDispatch::IntegrationTest

  test "user adds new worker" do
    user = users(:jo)

    login(user, 'password')

    assert_difference ['mailer_size', 'User.count'] do
      post workers_path, params: { worker: { email: 'foo@bar.com' } }
    end

    assert_response :created
    assert_match /Email sent to <strong>foo@bar.com<\/strong>./, @response.body

    invite_email = last_email

    assert_equal 'foo@bar.com', invite_email.to[0]
  end

end
