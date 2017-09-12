class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable

  belongs_to :company

  default_scope { order('created_at DESC') }

  acts_as_tenant :company
  acts_as_mappable

  has_secure_token :access_token

  def name
    [self.first_name, self.last_name].compact.join(' ')
  end

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end
end
