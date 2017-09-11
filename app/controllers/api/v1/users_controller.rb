module Api
  module V1
    class UsersController < ApiController
      before_action :authenticate

      def show
      end

      def update
        @profile = ProfileForm.new(current_user)

        if @profile.update(params)
          render status: :ok
        else
          head :unprocessable_entity
        end
      end

      def update_password
        @user_form = PasswordForm.new(current_user)

        if @user_form.update(params)
          head :ok
        else
          render json: @user_form.errors, status: :unprocessable_entity
        end
      end

    end
  end
end
