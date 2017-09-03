class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  set_current_tenant_through_filter
  before_action :set_company

  rescue_from ActiveRecord::RecordNotFound do
    render_404
  end

protected

  def set_company
    company = nil
    if user_signed_in?
      company  ||= current_user.company
    end
    set_current_tenant(company)
  end

  def render_404
    respond_to do |format|
      format.html do
        render file: Rails.root.join('public', '404'), layout: false, status: '404'
      end
      format.any { head :not_found }
    end
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || root_path
  end

end
