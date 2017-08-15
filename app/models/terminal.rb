class Terminal < ApplicationRecord
  validates :name, presence: true,
                    length: { maximum: 255 }

  default_scope { order(created_at: :desc, name: :asc) }

  before_create :create_pairing_token

  def generate_pairing_token_qr
    url = "https://spectre.com/#{self.pairing_token}"
    qr_code = RQRCode::QRCode.new(url, size: 4, level: :m)
    qr_code.as_svg(offset: 0, color: '000', module_size: 6)
  end

  private

    def create_pairing_token
      self.pairing_token = SecureRandom.hex(10)
    end
end
