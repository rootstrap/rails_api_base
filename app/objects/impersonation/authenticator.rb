# frozen_string_literal: true

module Impersonation
  class Authenticator
    def initialize(signed_data)
      @signed_data = signed_data
    end

    def build_auth_headers!
      user.tokens.reject! { |_token, attrs| attrs['impersonated_by'] == admin_user_id }
      user.build_auth_headers(token.token, token.client)
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
      @token ||= user.create_token(lifespan: 1.hour.to_i, impersonated_by: admin_user_id).tap { user.save! }
    end
  end
end
