class Company < ApplicationRecord
  has_many :users
  has_many :alerts

  validates :name, presence: true
  validates :name, length: { maximum: 255 }
end
