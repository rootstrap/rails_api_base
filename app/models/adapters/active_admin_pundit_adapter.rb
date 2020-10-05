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
        return Pundit.policy!(user, subject) if active_admin_namespace?(subject)

        get_policy(subject.class, user, subject)
      end
    end

    def scope_collection(collection, _action = Auth::READ)
      return collection if valid_collection_class?(collection)

      namespaced_policy(collection).new(user, collection).resolve
    rescue Pundit::NotDefinedError => e
      raise e unless policy_has_scope?(default_policy_class)

      default_policy_class::Scope.new(user, collection).resolve
    end

    private

    def namespaced_policy(collection)
      "ActiveAdmin::#{collection}Policy::Scope".constantize
    end

    def policy_has_scope?(policy)
      policy&.const_defined?(:Scope)
    end

    def valid_collection_class?(collection)
      collection.class != Class
    end

    def active_admin_namespace?(subject)
      subject.class.to_s.split('::')[0] == 'ActiveAdmin'
    end
  end
end
