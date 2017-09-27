class UserForm < ApplicationForm
  attr_accessor :email

  validate :verify_unique_email
  validates :email, format: { with: /\A[^@\s]+@[^@\s]+\z/ }

  delegate :email, to: :user

  def initialize(user = nil)
    super(nil)
    @user = user
  end

  def persisted?
    user.persisted?
  end

  def user
    @user ||= User.new
  end

  def password
    @password ||= Devise.friendly_token.first(8)
  end

  def submit(params)
    user.email = params[:email]
    user.password = password
    user.role = :user

    if valid?
      user.skip_confirmation!
      user.save!
      send_credentials
      true
    else
      false
    end
  end

  def send_credentials
    WorkersMailer.credentials(user.email, password).deliver_later
  end

  def verify_unique_email
    if User.exists?(email: email)
      errors.add(:email, "has already been taken")
    end
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, "User")
  end
end
