class NoticeJob < ApplicationJob
  queue_as :critical

  def perform(guard_id, alert_id)
    alert = Alert.find(alert_id)
    Pusher.trigger("private-#{guard_id}", "notice", guard: guard_id, alert: alert)
  end
end
