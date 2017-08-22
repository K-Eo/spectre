class Device::PairingsController < ApplicationController

  def create
    @terminal = Terminal.find_by(pairing_token: pairing_token_param)

    if @terminal.nil?
      @device = Device.new(device_params)
      render status: :not_found
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

private

    def pairing_token_param
      params.require(:device).permit(:pairing_token)[:pairing_token]
    end

    def device_params
      params.require(:device).permit(:imei, :os, :phone, :owner, :model)
    end
end
