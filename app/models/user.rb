class User < ApplicationRecord
  enum role: [:guest, :user, :moderator, :admin, :root]
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable

  default_scope { order("created_at DESC") }

  acts_as_mappable

  belongs_to :company

  # As a company worker
  has_many :issued_alerts, class_name: "Alert", foreign_key: "user_id", dependent: :destroy

  # As a company guard
  has_many :notices, dependent: :destroy
  has_many :alert_notices, through: :notices, source: :alert

  has_secure_token :access_token

  def notify_alert(alert)
    alert_notices << alert
  end

  def name
    [self.first_name, self.last_name].compact.join(" ")
  end

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end
end
