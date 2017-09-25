class ProfilePolicy < ApplicationPolicy

  def permitted_attributes
    [:first_name, :last_name]
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
