module Adapters
  class ActiveAdminPunditAdapter < ActiveAdmin::PunditAdapter
    def get_policy(subject, user, resource)
      "ActiveAdmin::#{subject}Policy".constantize.new(user, resource)
    end

    def retrieve_policy(subject)
      case subject
      when nil then get_policy(subject, user, resource)
      when Class then get_policy(subject, user, subject.new)
      else
        subject_class = subject.class
        if subject_class.to_s.split('::')[0] == 'ActiveAdmin'
          Pundit.policy!(user, subject)
        else
          get_policy(subject_class, user, subject)
        end
      end
    end

    def scope_collection(collection, _action = Auth::READ)
      return collection if collection.class != Class

      scope = "ActiveAdmin::#{collection}Policy::Scope".constantize
      scope.new(user, collection).resolve
    rescue Pundit::NotDefinedError => e
      raise e unless default_policy_class&.const_defined?(:Scope)

      default_policy_class::Scope.new(user, collection).resolve
    end
  end
end
