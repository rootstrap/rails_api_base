# frozen_string_literal: true

module Admin
  class UserPolicy < Admin::ApplicationPolicy
    def impersonate?
      true
    end

    def stop_impersonating?
      true
    end
  end
end
