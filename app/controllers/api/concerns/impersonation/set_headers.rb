# frozen_string_literal: true

module API
  module Concerns
    module Impersonation
      module SetHeaders
        extend ActiveSupport::Concern

        included do
          after_action do
            response.headers.merge!(
              ::Impersonation::Headers.new(current_user, request.headers['Access-Token']).build_impersonation_header
            )
          end
        end
      end
    end
  end
end
