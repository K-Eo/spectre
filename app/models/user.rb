class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable

  belongs_to :tenant

  before_validation :create_tenant

  accepts_nested_attributes_for :tenant

  def create_tenant
    ActsAsTenant.without_tenant do
      self.tenant.save if !self.tenant.nil?
    end
  end
end
