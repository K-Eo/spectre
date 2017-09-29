class ChannelsController < ApplicationController
  before_action :authenticate_user!

  def show
    render json: { private: "private-#{current_user.id}" }
  end
end
