class DeviceEmail
  include ActiveModel::Model

  attr_accessor(
    :email
  )

  validates :email, presence: true
  validates_format_of :email, with: /@/
end
