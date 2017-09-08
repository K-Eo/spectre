module Api
  module V1
    class AuthsController < ActionController::Base
      before_action :authenticate, only: [:destroy]

      def create
        if params[:email].blank? || params[:password].blank?
          head :bad_request
          return
        end

        @user = User.find_by(email: params[:email])

        if @user.nil?
          head :bad_request
        elsif @user.valid_password?(params[:password])
          @user.regenerate_access_token
          render
        else
          head :bad_request
        end
      end

      def destroy
        @user.access_token = nil
        @user.save
        head :ok
      end

      private

        def authenticate
          authenticate_or_request_with_http_token do |token, options|
            @user = User.find_by(access_token: token)
            !@user.nil?
          end
        end

    end
  end
end
