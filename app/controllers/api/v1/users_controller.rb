module Api
  module V1
    class UsersController < Api::V1::ApiController
      before_action :auth_user

      def show
        render jsonapi: current_user
      end

      def update
        if current_user.update(user_params)
          render jsonapi: current_user
        else
          render jsonapi_errors: current_user.errors, status: :unprocessable_entity
        end
      end

      private

      def auth_user
        authorize current_user
      end

      def user_params
        jsonapi_deserialize(params, only: [:username, :first_name, :last_name, :email])
      end
    end
  end
end
