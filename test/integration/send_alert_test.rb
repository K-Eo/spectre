require "test_helper"

class SendAlertTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  test "user can send alerts to guards" do
    user = users(:eo)
    params = { alert: { text: "foobar" } }

    assert_enqueued_jobs 0

    assert_difference "Notice.count", 3 do
      post api_v1_alerts_path, params: params, headers: token_header(user)
    end

    assert_enqueued_jobs 3

    assert_response :created
  end
end
