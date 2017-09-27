class Users::ProfilesController < ApplicationController
  def update
    @user = policy_scope(User).find(params[:id])
    @profile = ProfileForm.new(@user)
    authorize @profile

    if @profile.update(permitted_attributes(Profile))
      flash[:notice] = "Datos guardados"
      redirect_to user_path(@user)
    else
      redirect_to user_path(@user)
    end
  end
end
