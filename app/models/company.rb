class Company < ApplicationRecord
  has_many :companies

  validates :name, presence: true
  validates :name, length: { maximum: 255 }
end
