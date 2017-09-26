class Users::PasswordsController < ApplicationController

  def update
    @user = policy_scope(User).find(params[:id])
    @password = SecretForm.new(@user)

    if @password.update(permitted_attributes(Password))
      bypass_sign_in(@user)
      flash[:notice] = 'Su contraseña ha sido actualizada'
      redirect_to user_path(@user)
    else
      flash[:danger] = 'No se ha podido actualizar su contraseña'
      redirect_to user_path(@user)
    end
  end
end
