class Users::EmailsController < ApplicationController

  def update
    @user = policy_scope(User).find(params[:id])
    @email = EmailForm.new(@user)

    if @email.update(permitted_attributes(Email))
      flash[:notice] = 'Recibirá un correo con instrucciones para confirmar su nueva dirección de correo electrónico'
      redirect_to user_path(@user)
    else
      flash[:danger] = 'No se ha podido actualizar su cuenta de correo electrónico'
      redirect_to user_path(@user)
    end
  end
end
