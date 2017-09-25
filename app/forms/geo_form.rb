class GeoForm < ApplicationForm
  attr_accessor :lat
  attr_accessor :lng

  validates :lat, numericality: true
  validates :lng, numericality: true

  delegate :lat, :lng, to: :user

  def update(params)
    user.assign_attributes(params)

    if valid?
      user.save!
      true
    else
      false
    end
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, 'User')
  end

end
