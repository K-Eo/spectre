class Alert < ApplicationRecord
  enum state: { created: 0, opened: 4, closed: 10 }
  belongs_to :company
  belongs_to :issuing, class_name: "User", foreign_key: "user_id"
end
