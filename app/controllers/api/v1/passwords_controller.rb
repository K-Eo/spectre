class Api::V1::PasswordsController < Api::V1::ApiControllerBase
  def update
    @user_form = PasswordForm.new(current_user)

    if @user_form.update(params)
      head :ok
    else
      render json: @user_form.errors, status: :unprocessable_entity
    end
  end
end
