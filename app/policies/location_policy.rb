class LocationPolicy < ApplicationPolicy

  def permitted_attributes
    [:lat, :lng]
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
