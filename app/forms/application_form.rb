class ApplicationForm
  include ActiveModel::Model

  def initialize(user)
    @user = user
  end

  def user
    @user
  end

  def persisted?
    user.persisted?
  end
end
