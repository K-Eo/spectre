module Api
  module V1
    class SessionsController < ApiControllerBase
      skip_before_action :authenticate, only: [:create]

      def create
        @user = User.find_by(email: params[:email])

        if @user.nil?
          head :bad_request
        elsif @user.valid_password?(params[:password])
          @user.regenerate_access_token
          render status: :created
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
