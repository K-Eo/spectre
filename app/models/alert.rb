class Alert < ApplicationRecord
  belongs_to :company
  belongs_to :issuing, class_name: "User", foreign_key: "user_id"
end
