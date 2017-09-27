class AlertPolicy < ApplicationPolicy
  def permitted_attributes
    [:text]
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
