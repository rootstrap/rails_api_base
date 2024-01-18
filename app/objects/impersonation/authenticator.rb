# frozen_string_literal: true

module Impersonation
  class Authenticator
    TOKEN_KEY = 'impersonated_by'
    HEADER = { impersonated: true }.freeze

    def initialize(signed_data)
      @signed_data = signed_data
    end

    def build_auth_headers!
      user.tokens.reject! { |_token, attrs| attrs[TOKEN_KEY] == admin_user_id }
      user.build_auth_headers(token.token, token.client).merge(HEADER)
    end

    private

    def data
      @data ||= Impersonation::Verifier.new.verify!(@signed_data)
    end

    def user
      @user ||= User.find(data['user_id'])
    end

    def admin_user_id
      data['admin_user_id']
    end

    def token
      @token ||= user.create_token(lifespan: 1.hour.to_i, TOKEN_KEY => admin_user_id).tap { user.save! }
    end
  end
end
