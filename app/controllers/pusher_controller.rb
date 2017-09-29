class PusherController < ApplicationController
  def auth
    if current_user && params[:channel_name] == "private-#{current_user.id}"
      response = Pusher.authenticate(params[:channel_name], params[:socket_id])
      render json: response
    else
      render text: "Forbidden", status: 403
    end
  end

  def channels
    render json: { private: "private-#{current_user.id}" }
  end
end
