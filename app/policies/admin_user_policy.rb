# frozen_string_literal: true

class AdminUserPolicy < ApplicationPolicy
  def impersonate?
    true
  end
end
