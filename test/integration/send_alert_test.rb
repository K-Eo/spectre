require "test_helper"

class SendAlertTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  test "user can send alerts to guards" do
    user = users(:eo)
    params = { alert: { text: "send_alert_test" } }

    assert_enqueued_jobs 0

    assert_difference "Notice.count", 3 do
      post api_v1_alerts_path, params: params, headers: token_header(user)
    end

    assert_enqueued_jobs 3

    assert_response :created

    alert = Alert.find_by(text: 'send_alert_test')

    assert_equal alert.guards.count, 3
    assert alert.has_guard?(users(:mia))
    assert alert.has_guard?(users(:lee))
    assert alert.has_guard?(users(:tom))
  end
end
