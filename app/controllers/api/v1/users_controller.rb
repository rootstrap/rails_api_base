# frozen_string_literal: true

module API
  module V1
    class UsersController < API::V1::APIController
      before_action :auth_user

      def show; end

      def update
        current_user.update!(user_params)
        render :show
      end

      private

      def auth_user
        authorize current_user
      end

      def user_params
        params.require(:user).permit(:username, :first_name, :last_name, :email)
      end
    end
  end
end
