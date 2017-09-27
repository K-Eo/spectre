class EmailForm < ApplicationForm
  attr_accessor :email
  attr_accessor :current_password

  validates :email, format: { with: /\A[^@\s]+@[^@\s]+\z/ }

  delegate :id, :email, to: :user

  def update(params)
    user.update_with_password(params)
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, "Email")
  end
end
