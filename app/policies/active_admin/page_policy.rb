module ActiveAdmin
  class PagePolicy < ActiveAdmin::ApplicationPolicy
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
