class UserPolicy < ApplicationPolicy
  def show?
    true
  end

  def profile?
    update?
  end

  def update?
    user.id == record.id || super
  end
end
