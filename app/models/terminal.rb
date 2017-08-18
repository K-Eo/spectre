class Terminal < ApplicationRecord
  has_many :devices, dependent: :destroy, before_add: :set_current_device
  validates :name, presence: true,
                    length: { maximum: 255 }

  default_scope { order(created_at: :desc, name: :asc) }

  after_create :generate_tokens

  has_secure_token :access_token
  has_secure_token :pairing_token

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
    self.devices.where(current: true)
                .update_all(current: false)
  end

  def generate_tokens
    self.regenerate_access_token
    self.regenerate_pairing_token
  end

end
