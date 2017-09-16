class WorkerForm < ApplicationForm
  attr_accessor :email

  validate :verify_unique_email
  validates :email, format: { with: /\A[^@\s]+@[^@\s]+\z/ }

  delegate :email, to: :worker

  def initialize
    super(nil)
  end

  def persisted?
    worker.persisted?
  end

  def worker
    @worker ||= User.new
  end

  def password
    @password ||= Devise.friendly_token.first(8)
  end

  def submit(params)
    worker.email = params.require(:worker).permit(:email)[:email]
    worker.password = password

    if valid?
      worker.skip_confirmation!
      worker.save!
      send_credentials
      true
    else
      false
    end
  end

  def send_credentials
    WorkersMailer.credentials(worker.email, password).deliver_later
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
