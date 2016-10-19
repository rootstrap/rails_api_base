# encoding: utf-8

module Api
  module V1
    class RegistrationsController < DeviseTokenAuth::RegistrationsController
      def sign_up_params
        params.require(:user).permit(:email, :password, :password_confirmation, :username)
      end

      def render_create_success
        render json: resource_data
      end
    end
  end
end
