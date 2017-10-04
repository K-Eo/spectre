class Permissions::MonitorsController < ApplicationController
  before_action :set_user

  def update
    @user.update_attribute(:monitor, true)
  end

  def destroy
    @user.update_attribute(:monitor, false)
  end

private

  def set_user
    @user = User.find(params[:user_id])
  end
end