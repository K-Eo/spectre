class Terminal < ApplicationRecord
  has_many :devices, dependent: :destroy
  has_one :device, -> { where(current: true) }

  validates :name, presence: true,
                    length: { maximum: 255 }

  default_scope { order(created_at: :desc, name: :asc) }

  has_secure_token :access_token
  has_secure_token :pairing_token

  acts_as_tenant(:tenant)

  def pairing_token_png(size = 120)
    url = "https://spectre.com/#{self.pairing_token}"
    qr_code = RQRCode::QRCode.new(url, size: 4, level: :m)
    qr_code.as_png(
          resize_gte_to: false,
          resize_exactly_to: false,
          fill: 'white',
          color: 'black',
          size: size,
          border_modules: 0,
          module_px_size: 0,
          file: nil # path to write
          )
  end

  def set_current_device(device)
    # Pair device
    self.paired = true
    self.pairing_token = nil
    self.save

    # Regenerate fresh access token for device
    self.regenerate_access_token

    # Un pair current device
    self.devices.where.not(imei: device.imei)
                .where(current: true)
                .update_all(current: false)
  end

  def unpair_device
    # Set current device to false
    self.devices
        .where(current: true)
        .update_all(current: false)

    # To start pairing a new device later we set:
    # access_token to nil and paired to false,
    self.access_token = nil
    self.paired = false
    self.save

    # also we have to regenerate a new fresh pairing_token.
    self.regenerate_pairing_token
  end

end
