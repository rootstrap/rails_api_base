# frozen_string_literal: true

module Impersonation
  class Headers
    def initialize(user)
      @user = user
    end

    def build_impersonation_header
      { 'impersonated' => @user&.impersonated_by.present? }.compact_blank
    end
  end
end
