class SecretForm < ApplicationForm
  attr_accessor :password
  attr_accessor :password_confirmation
  attr_accessor :current_password

  delegate :id, to: :user

  def update(params)
    user.update_with_password(params)
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, 'Password')
  end

end
