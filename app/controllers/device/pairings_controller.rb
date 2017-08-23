class Device::PairingsController < ApplicationController

  rescue_from ActiveRecord::RecordNotFound do
    render_404
  end

  def create
    unless params[:device].present?
      render json: '', status: :bad_request
      return
    end

    @terminal = Terminal.find_by(pairing_token: pairing_token_param)

    if @terminal.nil?
      @device = Device.new(device_params)
      render json: '', status: :not_found
      return
    end

    @device = @terminal.devices.new(device_params)
    @device.current = true

    if @device.save
      @terminal.set_current_device(@device)
      render status: :created
    else
      render status: :unprocessable_entity
    end
  end

  def destroy
    access_token = params[:token]

    if access_token.nil?
      render status: :bad_request
      return
    end

    terminal = Terminal.find_by(access_token: access_token)

    if terminal.nil?
      render status: :bad_request
      return
    else
      terminal.unpair_device
      render status: :ok
    end
  end

private

    def pairing_token_param
      params.require(:device).permit(:pairing_token)[:pairing_token]
    end

    def device_params
      params.require(:device).permit(:imei, :os, :phone, :owner, :model)
    end
end
