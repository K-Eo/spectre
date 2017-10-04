class Company < ApplicationRecord
  enum kind: [:business, :security]
  has_many :users
  has_many :alerts

  validates :name, presence: true
  validates :name, length: { maximum: 255 }
end
