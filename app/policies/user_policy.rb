class UserPolicy < ApplicationPolicy
  def show?
    update?
  end

  def update?
    user.id == record.id || super
  end
end
