# encoding: utf-8

module Api
  module V1
    class RegistrationsController < DeviseTokenAuth::RegistrationsController
      protect_from_forgery with: :null_session

      api :POST, '/users', 'Registrate a new user'
      error code: 422, desc: 'Wrong params'
      param :user, Hash, desc: 'User information', required: true do
        param :email, String, required: true
        param :password, String, required: true
        param :password_confirmation, String, required: true
        param :username, String
        param :first_name, String
        param :last_name, String
      end

      def sign_up_params
        params.require(:user).permit(:email, :password, :password_confirmation, :username)
      end

      def render_create_success
        render json: resource_data
      end
    end
  end
end
