class AdminUserPolicy < ApplicationPolicyq
  def index?
    user.is_a?(AdminUser)
  end

  def show?
    user.is_a?(AdminUser)
  end

  def create?
    user.is_a?(AdminUser)
  end

  def update?
    user.is_a?(AdminUser)
  end

  def edit?
    update?
  end

  def destroy?
    user.is_a?(AdminUser)
  end
end
