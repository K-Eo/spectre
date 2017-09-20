class UserPolicy < ApplicationPolicy

  def index?
    record.company_id == user.company.id
  end

  def new?
    true
  end

  class Scope < Scope
    def resolve
      scope.where(company_id: user.company.id)
    end
  end
end
