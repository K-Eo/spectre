class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  set_current_tenant_through_filter

protected

  def set_organization
    @tenant = Tenant.find_by(organization: params[:organization])
    if @tenant.nil?
      redirect_to root_path
    else
      set_current_tenant(@tenant)
    end
  end

  def render_404
    respond_to do |format|
      format.html do
        render file: Rails.root.join('public', '404'), layout: false, status: '404'
      end
      format.any { head :not_found }
    end
  end

end
