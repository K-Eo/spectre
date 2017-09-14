class Alert < ApplicationRecord
  belongs_to :emitter, class_name: 'User', foreign_key: 'user_id'

  has_many :alert_events
  has_many :guards, through: :alert_events

  acts_as_tenant :company
end
