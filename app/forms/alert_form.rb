class AlertForm < ApplicationForm
  attr_accessor :text

  validates :text, length: { maximum: 255 }
  delegate :text, to: :alert

  def initialize(user)
    super(user)
    @alert = @user.issued_alerts.new
    @alert.company_id = @user.company_id
  end

  def alert
    @alert
  end

  def update(params)
    alert.assign_attributes(params)

    if valid?
      alert.save!
      notify_guards
      true
    else
      false
    end
  end

private

  def notify_guards
    guards = User.within(5, units: :kms, origin: user)
                 .joins(:company)
                 .where(companies: { kind: :security })

    guards.each do |guard|
      guard.notify_alert(alert)
      NoticeJob.perform_later(guard.id, alert.id)
    end
  end
end
