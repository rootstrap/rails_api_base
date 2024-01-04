# frozen_string_literal: true

module API
  module V1
    class UsersController < API::V1::APIController
      before_action :auth_user, except: [:impersonate]
      skip_before_action :authenticate_user!, only: [:impersonate]
      skip_after_action :verify_authorized, only: :impersonate

      def impersonate
        crypt = ActiveSupport::MessageEncryptor.new(Rails.application.secrets)
        decrypted_params = JSON.parse(
          crypt.decrypt_and_verify!(Base64.urlsafe_decode64(params['queryParams']), purpose: 'impersonation')
        )
        
        user.tokens.filter! { |_token, attrs| attrs['impersonated_by'] != decrypted_params['admin_user_id'] }
        
        # Creates the token
        token = user.create_token(lifespan: 1.hour.to_i, impersonated_by: decrypted_params['admin_user_id'])
        user.save!

        response.headers.merge!(user.build_auth_headers(token.token, token.client))
      end

      def show; end

      def update
        current_user.update!(user_params)
        render :show
      end

      private

      def auth_user
        authorize current_user
      end

      def user
        @user ||= User.find(params[:id])
      end

      def user_params
        params.require(:user).permit(:username, :first_name, :last_name, :email)
      end
    end
  end
end
