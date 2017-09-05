class WorkerForm
  include ActiveModel::Model

  attr_accessor :email

  validate :verify_unique_email
  validates :email, format: { with: /\A[^@\s]+@[^@\s]+\z/ }

  delegate :email, to: :user

  def user
    @user ||= User.new
  end

  def submit(params)
    password = Devise.friendly_token.first(8)
    user.assign_attributes(params.permit(:email))
    user.password = password
    if valid?
      user.skip_confirmation!
      user.save!
      true
    else
      false
    end
  end

  def verify_unique_email
    ActsAsTenant.without_tenant do
      if User.exists?(email: email)
        errors.add(:email, 'has already been taken')
      end
    end
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, 'Worker')
  end
end
