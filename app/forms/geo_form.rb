class GeoForm
  include ActiveModel::Model

  attr_accessor :lat
  attr_accessor :lng

  validates :lat, numericality: true
  validates :lng, numericality: true

  delegate :lat, :lng, to: :user

  def initialize(user)
    @user = user
  end

  def user
    @user
  end

  def persisted?
    user.persisted?
  end

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
