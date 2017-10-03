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
      true
    else
      false
    end
  end
end
