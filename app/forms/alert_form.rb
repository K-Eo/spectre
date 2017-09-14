class AlertForm < ApplicationForm
  attr_accessor :text

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
      true
    else
      false
    end
  end

private

  def alert_params(params)
    params.require(:alert).permit(:text)
  end

end
