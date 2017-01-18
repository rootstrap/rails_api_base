# encoding: utf-8

module Api
  module V1
    class RegistrationsController < DeviseTokenAuth::RegistrationsController
      protect_from_forgery with: :exception
      skip_before_filter :verify_authenticity_token, if: :json_request?

      def sign_up_params
        params.require(:user).permit(:email, :password, :password_confirmation, :username)
      end

      def render_create_success
        render json: resource_data
      end

      private

      def json_request?
        request.format.json?
      end
    end
  end
end
