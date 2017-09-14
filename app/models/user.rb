class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable

  default_scope { order('created_at DESC') }

  acts_as_mappable

  acts_as_tenant :company
  belongs_to :company

  # As a company worker
  has_many :issued_alerts, class_name: 'Alert', foreign_key: 'user_id'

  # As a company guard
  has_many :alert_events
  has_many :alert_notifications, through: :alert_events

  has_secure_token :access_token

  def name
    [self.first_name, self.last_name].compact.join(' ')
  end

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end
end
