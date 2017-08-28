class Tenant < ApplicationRecord
  has_many :users, dependent: :delete_all

  validates :name, presence: true,
                    length: { maximum: 255 }
  validates :organization, presence: true,
                            length: { maximum: 50 },
                            uniqueness: true
end
