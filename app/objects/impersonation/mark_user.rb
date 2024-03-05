# frozen_string_literal: true

module Impersonation
  class MarkUser
    def initialize(user, access_token)
      @user = user
      @access_token = access_token
    end

    def mark!
      return unless impersonation_token?

      @user.impersonated_by = impersonated_by
    end

    private

    def token
      @token ||= @user&.tokens&.values&.find do |data|
        DeviseTokenAuth::TokenFactory.token_hash_is_token?(
          data['token'], @access_token
        )
      end
    end

    def impersonation_token?
      token&.key?(::Impersonation::Authenticator::TOKEN_KEY)
    end

    def impersonated_by
      token[::Impersonation::Authenticator::TOKEN_KEY]
    end
  end
end
