class Users::LocationController < ApplicationController

  def update
    @user = policy_scope(User).find(params[:id])
    @location = LocationForm.new(@user)
    authorize @location

    respond_to do |format|
      if @location.update(permitted_attributes(Location))
        format.js
      else
        format.js
      end
    end
  end

end
