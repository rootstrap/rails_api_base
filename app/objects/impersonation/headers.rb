# frozen_string_literal: true

module Impersonation
  class Headers
    def initialize(user, access_token)
      @user = user
      @access_token = access_token
    end

    def build_impersonation_headers
      { impersonated: impersonation_token? }.compact_blank
    end

    private

    def token
      @user&.tokens&.values&.find do |data|
        DeviseTokenAuth::TokenFactory.token_hash_is_token?(
          data['token'], @access_token
        )
      end
    end

    def impersonation_token?
      token&.key?(::Impersonation::Authenticator::TOKEN_KEY)
    end
  end
end
