class NoticeJob < ApplicationJob
  queue_as :default

  def perform(guard_id, alert_id)
  end
end
