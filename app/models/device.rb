class Device < ApplicationRecord

  def self.fake
    device = Device.new
    device.imei = Faker::Code.imei
    device.os = Faker::Space.galaxy
    device.model = Faker::Space.planet
    device.owner = Faker::Name.name
    device.phone = Faker::PhoneNumber.cell_phone
    device
  end

end
