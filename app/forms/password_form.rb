class PasswordForm
  include ActiveModel::Model

  attr_accessor :password
  attr_accessor :password_confirmation
  attr_accessor :current_password

  delegate :errors, to: :user_errors

  def initialize(user)
    @user = user
  end

  def user_errors
    user
  end

  def user
    @user
  end

  def persisted?
    user.persisted?
  end

  def update(params)
    return false if params.nil? || params[:user].blank?

    user.update_with_password(user_params(params))
  end

  def self.model_name
    ActiveMode::Name.new(self, nil, 'User')
  end

private

  def user_params(params)
    params.require(:user).permit(:password, :password_confirmation, :current_password)
  end

end
