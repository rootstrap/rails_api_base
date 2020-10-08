module Admin
  class ApplicationPolicy
    attr_reader :user, :record

    def initialize(user, record)
      @user = user
      @record = record
    end

    def index?
      user.is_a?(AdminUser)
    end

    def show?
      user.is_a?(AdminUser)
    end

    def create?
      user.is_a?(AdminUser)
    end

    def new?
      create?
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

    class Scope
      attr_reader :user, :scope

      def initialize(user, scope)
        @user = user
        @scope = scope
      end

      def resolve
        scope.all
      end
    end
  end
end
