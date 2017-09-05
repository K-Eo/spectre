class WorkerForm
  include ActiveModel::Model

  attr_accessor :email

  validate :verify_unique_email
  validates :email, format: { with: /\A[^@\s]+@[^@\s]+\z/ }

  delegate :email, to: :user

  def initialize(params = {})
    user.email = params.fetch(:email, '')
  end

  def user
    @user ||= User.new
  end

  def password
    @password ||= Devise.friendly_token.first(8)
  end

  def submit
    user.password = password
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
    WorkersMailer.credentials(self).deliver_now
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
