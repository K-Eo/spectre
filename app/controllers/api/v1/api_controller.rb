module Api
  module V1
    class ApiController < ActionController::Base
      before_action :authenticate

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
  end
end
