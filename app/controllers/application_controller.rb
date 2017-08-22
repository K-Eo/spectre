class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  set_current_tenant_through_filter
  before_action :set_organization

  def set_organization
    @tenant = Tenant.find_by(organization: params[:organization])
    set_current_tenant(@tenant)
  end

  def default_url_options(options= {})
    { organization: params[:organization] }
  end

end
