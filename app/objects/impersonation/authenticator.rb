# frozen_string_literal: true

module Impersonation
  class Authenticator
    TOKEN_KEY = 'impersonated_by'

    def initialize(signed_data)
      @signed_data = signed_data
    end

    def authenticate!
      clean_up_previous_impersonations

      [user, token]
    end

    private

    def clean_up_previous_impersonations
      user.tokens.reject! { |_token, attrs| attrs[TOKEN_KEY] == admin_user_id }
    end

    def data
      @data ||= Impersonation::Verifier.new.verify!(@signed_data)
    end

    def user
      @user ||= User.find(data['user_id']).tap do |it|
        it.impersonated_by = admin_user_id
      end
    end

    def admin_user_id
      data['admin_user_id']
    end

    def token
      user.create_token(lifespan: 1.hour.to_i, TOKEN_KEY => admin_user_id).tap { user.save! }
    end
  end
end
