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
    return false if params.nil? || params[:alert].blank?

    alert.assign_attributes(alert_params(params))

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
    guards = User.within(1, units: :kms, origin: user).where.not(id: user.id)
    guards.each do |guard|
      guard.notify_alert(alert)
      AlertNotificationJob.perform_later
    end
  end

  def alert_params(params)
    params.require(:alert).permit(:text)
  end

end
