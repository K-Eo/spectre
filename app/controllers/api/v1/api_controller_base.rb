class Api::V1::ApiControllerBase < ActionController::Base
  include Pundit
  before_action :authenticate

rescue_from ActionController::ParameterMissing do
  respond_to do |format|
    format.any { head :bad_request }
  end
end

  def current_user
    @user
  end

protected

  def authenticate
    authenticate_or_request_with_http_token do |token, options|
      @user = User.find_by(access_token: token)
      !@user.nil?
    end
  end
end
