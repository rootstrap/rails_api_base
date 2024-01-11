# frozen_string_literal: true

module Impersonation
  class Authenticator
    def initialize(encrypted_data)
      @encrypted_data = encrypted_data
    end

    def build_auth_headers!
      user.tokens.reject! { |_token, attrs| attrs['impersonated_by'] == admin_user_id }
      user.build_auth_headers(token.token, token.client) if user.save!
    end

    private

    def decrypted_data
      @decrypted_data ||= Impersonation::Encryptor.new.decrypt!(@encrypted_data)
    end

    def user
      @user ||= User.find(@decrypted_data['user_id'])
    end

    def admin_user_id
      decrypted_data['admin_user_id']
    end

    def token
      @token ||= user.create_token(lifespan: 1.hour.to_i, impersonated_by: admin_user_id)
    end
  end
end
