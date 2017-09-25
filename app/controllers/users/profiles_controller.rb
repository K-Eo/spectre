class Users::ProfilesController < ApplicationController

  def update
    @user = policy_scope(User).find(params[:id])
    @profile = ProfileForm.new(@user)
    authorize @profile

    respond_to do |format|
      if @profile.update(permitted_attributes(Profile))
        format.js
      else
        format.js
      end
    end
  end
end
