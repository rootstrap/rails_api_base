# encoding: utf-8

module Api
  module V1
    class SessionsController < DeviseTokenAuth::SessionsController
      protect_from_forgery with: :null_session
      include Api::Concerns::ActAsApiRequest

      def facebook
        user_params = FacebookService.new(params[:access_token]).profile
        @resource = User.from_social_provider 'facebook', user_params
        custom_sign_in
      rescue Koala::Facebook::AuthenticationError
        render json: { error: I18n.t('api.facebook.not_authorized') }, status: :forbidden
      rescue ActiveRecord::RecordNotUnique
        render json: { error: I18n.t('api.facebook.already_registerd') }, status: :bad_request
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
