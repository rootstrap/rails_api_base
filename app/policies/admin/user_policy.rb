# frozen_string_literal: true

module Admin
  class UserPolicy < Admin::ApplicationPolicy
    def impersonate?
      true
    end

    def stop_impersonation?
      true
    end

    def masquerade_authorize!
      true
    end
  end
end
