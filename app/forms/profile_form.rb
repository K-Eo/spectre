class ProfileForm < ApplicationForm
  attr_accessor :first_name
  attr_accessor :last_name

  validates :first_name, length: { maximum: 255 },
                         format: { with: /\A[a-zA-Z\s]*\z/ }

  validates :last_name, length: { maximum: 255 },
                        format: { with: /\A[a-zA-Z\s]*\z/ }

  delegate :first_name, :last_name, to: :user

  def update(params)
    return false if params.nil? || params[:profile].blank?

    user.assign_attributes(params.require(:profile).permit(:first_name, :last_name))

    if valid?
      user.save!
      true
    else
      false
    end
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, 'Profile')
  end
end
