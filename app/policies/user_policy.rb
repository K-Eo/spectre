class UserPolicy < ApplicationPolicy

  def index?
    user.admin? || user.moderator?
  end

  def new?
    user.admin? || user.moderator?
  end

  class Scope < Scope
    def resolve
      if user.admin? || user.moderator?
        scope.where(company_id: user.company.id)
      else
        scope.where(company_id: nil)
      end
    end
  end
end
