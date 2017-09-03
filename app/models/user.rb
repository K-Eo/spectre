class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable

  belongs_to :company

  before_validation :create_company

  accepts_nested_attributes_for :company
  acts_as_tenant :company

  def create_company
    ActsAsTenant.without_tenant do
      self.company.save if !self.company.nil?
    end
  end
end
