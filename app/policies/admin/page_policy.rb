module Admin
  class PagePolicy < Admin::ApplicationPolicy
    def show?
      case record.name
      when 'Dashboard'
        true
      else
        false
      end
    end
  end
end
