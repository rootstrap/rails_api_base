# frozen_string_literal: true

module API
  module Concerns
    module Impersonation
      module SetHeaders
        extend ActiveSupport::Concern

        included do
          after_action do
            token = current_user&.tokens&.values&.find do |data|
              DeviseTokenAuth::TokenFactory.token_hash_is_token?(
                data['token'], request.headers['Access-Token']
              )
            end

            if token&.key?(::Impersonation::Authenticator::TOKEN_KEY)
              response.headers.merge!(::Impersonation::Authenticator::HEADER)
            end
          end
        end
      end
    end
  end
end
