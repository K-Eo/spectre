module Api
  module V1
    class UsersController < ApiControllerBase

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
