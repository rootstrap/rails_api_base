# frozen_string_literal: true

module Impersonation
  class ImpersonateService
    def initialize(impersonate_data)
      @impersonate_data = impersonate_data
    end

    def call
      user.tokens.filter! { |_token, attrs| attrs['impersonated_by'] != decrypted_data['admin_user_id'] }
      token = user.create_token(lifespan: 1.hour.to_i, impersonated_by: decrypted_data['admin_user_id'])
      user.save!

      user.build_auth_headers(token.token, token.client)
    end

    private

    def decrypted_data
      @decrypted_data ||= Impersonation::Encryptor.new.decrypt!(@impersonate_data)
    end

    def user
      @user ||= User.find(decrypted_data['user_id'])
    end
  end
end
