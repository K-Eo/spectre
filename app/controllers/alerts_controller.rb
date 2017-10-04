class AlertsController < ApplicationController
  before_action :authenticate_user!

  def index
    @alerts = current_company.alerts.includes(:issuing)
  end
end
