# frozen_string_literal: true

module API
  module V1
    class UsersController < API::V1::APIController
      before_action :auth_user, except: [:impersonate]
      skip_before_action :authenticate_user!, only: [:impersonate]

      def impersonate
        len = ActiveSupport::MessageEncryptor.key_len
        salt, encrypted_data = params['queryParams'].split '$$'
        encrypted_data = Base64.urlsafe_decode64(encrypted_data)
        key = ActiveSupport::KeyGenerator.new(Rails.application.secrets.secret_key_base).generate_key(salt, len)
        crypt = ActiveSupport::MessageEncryptor.new(key)
        decrypted_params = JSON.parse(crypt.decrypt_and_verify(encrypted_data, purpose: 'impersonation'))
        
        params['admin_user_id'] = decrypted_params['admin_user_id']
        params['expiry'] = decrypted_params['expiry']
        
        authorize admin_user
        
        # Checks if the request is valid
        render_parameter_missing('expiry cannot be blank') and return if params['expiry'].blank?

        # Render and return if Time.zone.now > expiry
        expiry = Time.zone.parse(params['expiry'])
        lifespan = expiry.to_i - Time.zone.now.to_i
        if Time.zone.now > expiry || lifespan.negative?
          render json: { error: 'Your request is no longer valid' }, status: :unprocessable_entity and return
        end

        # Deletes old tokens for the current admin user
        user.tokens.filter! { |_token, attrs| attrs['impersonated_by'] != params[:admin_user] }

        # Creates the token
        token = user.create_token(lifespan:, impersonated_by: params[:admin_user])
        user.save!

        # Generates the auth headers using the token
        @auth_headers = user.build_auth_headers(token.token, token.client)
        response.headers.merge!(@auth_headers)
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

      def admin_user
        @admin_user ||= AdminUser.find(params[:admin_user_id])
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
