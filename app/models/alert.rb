class Alert < ApplicationRecord
  enum state: { opened: 0, closed: 10 }
  belongs_to :company
  belongs_to :issuing, class_name: "User", foreign_key: "user_id"
end
