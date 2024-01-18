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

            response.headers['impersonated'] = true if token&.key?('impersonated_by')
          end
        end
      end
    end
  end
end
