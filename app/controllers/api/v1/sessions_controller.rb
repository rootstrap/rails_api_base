# encoding: utf-8

module Api
  module V1
    class SessionsController < DeviseTokenAuth::SessionsController
      protect_from_forgery with: :null_session

      api :POST, '/users/sign_in', 'Get client, token and uid for a new session'
      error code: 400, desc: 'Wrong credentials'
      param :user, Hash, desc: 'Credentials', required: true do
        param :email, String, required: true
        param :password, String, required: true
      end
      def create
        super
      end

      api :POST, '/users/facebook', 'Login with facebook'
      error code: 400, desc: 'User already registered with email/password'
      error code: 403, desc: 'Not Authorized'
      param :access_token, String, required: true
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

      def custom_sign_in
        sign_in(:api_v1_user, @resource)
        new_auth_header = @resource.create_new_auth_token
        # update response with the header that will be required by the next request
        response.headers.merge!(new_auth_header)
        render_create_success
      end
    end
  end
end
