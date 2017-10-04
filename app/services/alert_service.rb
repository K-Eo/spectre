class AlertService < Alert
  include AASM

  aasm column: :state, enum: true do
    state :created, initial: true
    state :opened, :closed

    event :open do
      transitions from: :created, to: :opened, success: :notify_users
    end

    event :close do
      transitions from: :opened, to: :closed
    end
  end

  def notify_users
    users = self.company.users.where(role: :moderator)
    actor = self.issuing

    users.each do |user|
      Notification.create(recipient: user, actor: issuing, action: 'created', notifiable: self)
    end
  end
end
