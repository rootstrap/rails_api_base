# encoding: utf-8

module Api
  module V1
    class UsersController < Api::V1::ApiController
      before_action :authenticate_user!

      api :GET, '/users/me', 'Show current user information'
      def show
      end

      api :UPDATE, '/users/me', 'Update current user information'
      error code: 400, desc: 'Wrong params'
      param :user, Hash, desc: 'User information', required: true do
        param :first_name, String
        param :last_name, String
        param :email, String
        param :username, String
      end
      def update
        current_user.update!(user_params)
        render :show
      end

      private

      def user_params
        params.require(:user).permit(:username, :first_name, :last_name, :email)
      end
    end
  end
end
