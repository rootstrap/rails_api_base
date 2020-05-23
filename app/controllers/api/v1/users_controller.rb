module Api
  module V1
    class UsersController < Api::V1::ApiController
      before_action :auth_user

      def show
        @user = UserPresenter.new(current_user)
      end

      def profile
        @user = UserPresenter.new(current_user)
        render :show
      end

      def update
        current_user.update!(user_params)
        @user = UserPresenter.new(current_user)
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
