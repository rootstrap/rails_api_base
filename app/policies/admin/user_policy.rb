# frozen_string_literal: true

module Admin
  class UserPolicy < Admin::ApplicationPolicy
    def impersonate?
      create? && Flipper.enabled?(:impersonation_tool)
    end
  end
end
