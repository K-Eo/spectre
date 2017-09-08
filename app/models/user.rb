class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable

  belongs_to :company

  default_scope { order('created_at DESC') }

  acts_as_tenant :company

  def name
    [self.first_name, self.last_name].compact.join(' ')
  end
end
