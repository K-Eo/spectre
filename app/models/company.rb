class Company < ApplicationRecord
  has_many :users

  validates :name, presence: true
  validates :name, length: { maximum: 255 }
end
