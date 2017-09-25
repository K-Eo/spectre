class Users::LocationsController < ApplicationController

  def update
    @user = policy_scope(User).find(params[:id])
    @location = LocationForm.new(@user)
    authorize @location

    if @location.update(permitted_attributes(Location))
      flash[:notice] = 'Datos guardados'
      redirect_to user_path(@user)
    else
      redirect_to user_path(@user)
    end
  end

end
