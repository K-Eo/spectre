class AlertNotificationJob < ApplicationJob
  queue_as :default

  def perform(*args)
  end
end
