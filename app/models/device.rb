class Device < ApplicationRecord
  belongs_to :terminal
  validates :imei, presence: true,
                    length: { maximum: 16 }
  validates :os, presence: true
  validates :phone, presence: true,
                    length: { maximum: 20 }
  validates :owner, presence: true,
                    length: { maximum: 120 }
  validates :model, presence: true

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
