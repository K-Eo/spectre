class Permissions::AlertsController < ApplicationController
  before_action :set_user

  def update
    @user.update_attribute(:create_alert, true)
  end

  def destroy
    @user.update_attribute(:create_alert, false)
  end

private

  def set_user
    @user = User.find(params[:user_id])
  end
end
