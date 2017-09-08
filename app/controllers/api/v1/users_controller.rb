# encoding: utf-8

module Api
  module V1
    class UsersController < Api::V1::ApiController
      helper_method :user

      def show; end

      def profile
        render :show
      end

      def update
        user.update!(user_params)
        render :show
      end

      private

      def user_params
        params.require(:user).permit(:username, :first_name, :last_name, :email)
      end

      def user
        @user ||= user_id.present? ? User.find(user_id) : current_user
      end

      def user_id
        params[:id]
      end
    end
  end
end
