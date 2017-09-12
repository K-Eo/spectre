class AlertForm
  include ActiveModel::Model

  attr_accessor :text

  delegate :text, to: :alert

  def initialize(user)
    @user = user
    @alert = @user.alerts.new
  end

  def alert
    @alert
  end

  def user
    @user
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
