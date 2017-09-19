class Alert < ApplicationRecord
  belongs_to :issued, class_name: 'User', foreign_key: 'user_id'

  has_many :alert_events
  has_many :guards, through: :alert_events

  acts_as_tenant :company

  def has_guard?(user)
    guards.include?(user)
  end

end
