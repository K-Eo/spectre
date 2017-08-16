class Sandbox::DeviceController < ApplicationController

  def index
    @device = Device.fake
  end

  def pairing
  end

  private

    def pairing_token
      params.require(:device).permit(:pairing_token)
    end

    def device_params
      params.require(:device).permit(:imei, :os, :phone, :owner, :model)
    end

end
