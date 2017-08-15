class Terminal < ApplicationRecord
  validates :name, presence: true,
                    length: { maximum: 255 }

  default_scope { order(created_at: :desc, name: :asc) }

  before_create :create_pairing_token

  private

    def create_pairing_token
      self.pairing_token = SecureRandom.hex(10)
    end
end
