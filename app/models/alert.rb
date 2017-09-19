class Alert < ApplicationRecord
  belongs_to :issuing, class_name: 'User', foreign_key: 'issuing_id'

  has_many :alert_events
  has_many :guards, through: :alert_events

  def has_guard?(user)
    guards.include?(user)
  end

end
