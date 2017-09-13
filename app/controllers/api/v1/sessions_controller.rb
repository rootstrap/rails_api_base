# encoding: utf-8

module Api
  module V1
    class SessionsController < DeviseTokenAuth::SessionsController
      protect_from_forgery with: :null_session
      include Concerns::ActAsApiRequest

      def create
        field = (resource_params.keys.map(&:to_sym) & resource_class.authentication_keys).first

        @resource = nil
        if field
          q_value = resource_params[field]

          if resource_class.case_insensitive_keys.include?(field)
            q_value.downcase!
          end

          q = "#{field} = ? AND provider='email'"

          if ActiveRecord::Base.connection.adapter_name.downcase.starts_with? 'mysql'
            q = 'BINARY ' + q
          end

          @resource = resource_class.where(q, q_value).first
        end

        if @resource && valid_params?(field, q_value) &&
           (!@resource.respond_to?(:active_for_authentication?) ||
           @resource.active_for_authentication?)
          valid_password = @resource.valid_password?(resource_params[:password])
          if (@resource.respond_to?(:valid_for_authentication?) &&
             !@resource.valid_for_authentication? { valid_password }) || !valid_password
            render_create_error_bad_credentials
            return
          end
          # create client id
          @client_id = SecureRandom.urlsafe_base64(nil, false)
          @token     = SecureRandom.urlsafe_base64(nil, false)

          @resource.tokens = JSON.parse(@resource.tokens) if @resource.tokens.is_a? String

          @resource.tokens[@client_id] = {
            token: BCrypt::Password.create(@token),
            expiry: (Time.now + DeviseTokenAuth.token_lifespan).to_i
          }
          @resource.save

          sign_in(:user, @resource, store: false, bypass: false)

          yield @resource if block_given?

          render_create_success
        elsif @resource && !(!@resource.respond_to?(:active_for_authentication?) ||
              @resource.active_for_authentication?)
          render_create_error_not_confirmed
        else
          render_create_error_bad_credentials
        end
      end

      def facebook
        user_params = FacebookService.new(params[:access_token]).profile
        @resource = User.from_social_provider 'facebook', user_params
        custom_sign_in
      rescue Koala::Facebook::AuthenticationError
        render json: { error: 'Not Authorized' }, status: :forbidden
      rescue ActiveRecord::RecordNotUnique
        render json: { error: 'User already registered with email/password' }, status: :bad_request
      end

      def resource_params
        params.require(:user).permit(:email, :password)
      end

      private

      def json_request?
        request.format.json?
      end

      def custom_sign_in
        sign_in(:api_v1_user, @resource)
        new_auth_header = @resource.create_new_auth_token
        # update response with the header that will be required by the next request
        response.headers.merge!(new_auth_header)
        render_create_success
      end

      def render_create_success
        render json: { user: resource_data }
      end
    end
  end
end
