module Api
  module V1
    class AuthsController < ApiController
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
        current_user.access_token = nil
        current_user.save
        head :ok
      end

    end
  end
end
