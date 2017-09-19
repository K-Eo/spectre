class AlertsController < ApplicationController
  before_action :authenticate_user!

  def index
    @alerts = company.alerts.includes(:issued, :guards)
  end

end
