class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception

  before_action :load_company
  helper_method :current_company

  rescue_from ActiveRecord::RecordNotFound do
    render_404
  end

  rescue_from Pundit::NotAuthorizedError do
    render_401
  end

  rescue_from ActionController::ParameterMissing do
    respond_to do |format|
      format.js { render status: :bad_request }
      format.any { head :bad_request }
    end
  end

  def current_user
    super || GuestUser.new
  end

protected

  def load_company
    if devise_controller? || current_user.is_a?(GuestUser)
      @company = nil
    else
      @company ||= current_user.company
    end
  end

  def current_company
    @company
  end

  def render_401
    respond_to do |format|
      format.html do
        render "pages/unauthorized", layout: false, status: :unauthorized
      end
      format.any { head :unauthorized }
    end
  end

  def render_404
    respond_to do |format|
      format.html do
        render file: Rails.root.join("public", "404"), layout: false, status: "404"
      end
      format.any { head :not_found }
    end
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || dashboard_path
  end
end
