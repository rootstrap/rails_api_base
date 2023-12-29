# frozen_string_literal: true

module API
  module V1
    class UsersController < API::V1::APIController
      before_action :auth_user, except: [:impersonate]
      skip_before_action :authenticate_user!, only: [:impersonate]
      skip_after_action :verify_authorized, only: :impersonate

      def impersonate
        # TODO use encryptorService para desencriptar queryParams
        len = ActiveSupport::MessageEncryptor.key_len
        salt, encrypted_data = params['queryParams'].split '$$'
        encrypted_data = Base64.urlsafe_decode64(encrypted_data)
        key = ActiveSupport::KeyGenerator.new(Rails.application.secrets.secret_key_base).generate_key(salt, len)
        crypt = ActiveSupport::MessageEncryptor.new(key)
        decrypted_params = JSON.parse(crypt.decrypt_and_verify(encrypted_data, purpose: 'impersonation'))
        # ----------------------------------------------- END
        
        render json: { error: 'Invalid session' } and return unless warden.authenticated?(:admin_user)


        # Checks if the request is valid
        # TODO create impersonate service
        render_parameter_missing('expiry cannot be blank') and return if decrypted_params['expiry'].blank?

        expiry = Time.zone.parse(decrypted_params['expiry'])
        lifespan = expiry.to_i - Time.zone.now.to_i
        if Time.zone.now > expiry || lifespan.negative?
          render json: { error: 'Your request is no longer valid' }, status: :unprocessable_entity and return
        end
        
        user.tokens.filter! { |_token, attrs| attrs['impersonated_by'] != decrypted_params['admin_user_id'] }
        

        # Creates the token
        token = user.create_token(lifespan:, impersonated_by: decrypted_params['admin_user_id'])
        user.save!

        # Generates the auth headers using the token
        @auth_headers = user.build_auth_headers(token.token, token.client)
        # ----------------------------------------------- END
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

      def user
        @user ||= User.find(params[:id])
      end

      def user_params
        params.require(:user).permit(:username, :first_name, :last_name, :email)
      end
    end
  end
end
