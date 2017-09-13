class GeoForm < ApplicationForm
  attr_accessor :lat
  attr_accessor :lng

  validates :lat, numericality: true
  validates :lng, numericality: true

  delegate :lat, :lng, to: :user

  def update(params)
    return false if params.nil? || params[:geo].blank?

    user.assign_attributes(geo_params(params))

    if valid?
      user.save!
      true
    else
      false
    end
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, 'Geo')
  end

private

  def geo_params(params)
    params.require(:geo).permit(:lat, :lng)
  end

end
