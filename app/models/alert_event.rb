class AlertEvent < ApplicationRecord
  belongs_to :guards, class_name: 'User', foreign_key: 'user_id'
  belongs_to :alert_notifications, class_name: 'Alert', foreign_key: 'alert_id'
end
