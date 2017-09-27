class Alert < ApplicationRecord
  belongs_to :company
  belongs_to :issuing, class_name: "User", foreign_key: "user_id"

  has_many :notices, dependent: :destroy
  has_many :guards, through: :notices, source: :user

  def has_guard?(user)
    guards.include?(user)
  end
end
