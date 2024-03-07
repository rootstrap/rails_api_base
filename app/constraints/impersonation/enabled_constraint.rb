# frozen_string_literal: true

module Impersonation
  class EnabledConstraint
    def matches?(_request)
      Flipper[:impersonation_tool].enabled? || Rails.env.test?
    end
  end
end
