# frozen_string_literal: true

module Api
  module V1
    class UsersController < Api::V1::ApiController
      before_action :auth_user
      respond_to :html

      def show
        respond_with :api, :v1, :show
      end

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
