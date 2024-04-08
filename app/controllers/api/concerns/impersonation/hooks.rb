# frozen_string_literal: true

module API
  module Concerns
    module Impersonation
      module Hooks
        extend ActiveSupport::Concern

        included do
          before_action do
            ::Impersonation::MarkUser.new(current_user, request.headers['Access-Token']).mark!

            response.headers.merge!(
              ::Impersonation::Headers.new(current_user).build_impersonation_header
            )
          end
        end
      end
    end
  end
end
