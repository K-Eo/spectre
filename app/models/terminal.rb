class Terminal < ApplicationRecord
  validates :name, presence: true,
                    length: { maximum: 255 }

  default_scope { order(created_at: :desc, name: :asc) }
end
