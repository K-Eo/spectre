class UserPolicy < ApplicationPolicy

  def index?
    user.admin? || user.moderator?
  end

  def new?
    user.admin? || user.moderator?
  end

  def create?
    (user.admin? || user.moderator?) &&
    (record.user.company_id == user.company_id)
  end

  def show?
    (user.admin? ||
    user.moderator? ||
    (record.id == user.id)) &&
    (record.company_id == user.company_id)
  end

  def geo?
    (user.admin? ||
    (user.moderator? && record.user?) ||
    (record.id == user.id)) &&
    (record.company_id == user.company_id)
  end

  def destroy?
    (user.admin? && !record.admin?) ||
    (user.moderator? && record.user?) ||
    (record.id == user.id && !record.admin?)
  end

  def permitted_attributes_for_create
    [:email]
  end

  def permitted_attributes_for_geo
    [:lat, :lng]
  end

  class Scope < Scope
    def resolve
      scope.where(company_id: user.company.id)
    end
  end
end
