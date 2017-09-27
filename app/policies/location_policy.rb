class LocationPolicy < ApplicationPolicy
  def update?
    (user.admin? ||
    (user.moderator? && record.user.user?) ||
    (record.user.id == user.id)) &&
    (record.user.company_id == user.company_id)
  end

  def permitted_attributes
    [:lat, :lng]
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
