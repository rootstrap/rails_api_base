# frozen_string_literal: true

module API
  module V1
    class SessionsController < DeviseTokenAuth::SessionsController
      include API::Concerns::ActAsAPIRequest
      protect_from_forgery with: :null_session

      private

      def resource_params
        params.require(:user).permit(:email, :password)
      end

      def render_create_success
        render :create
      end

      def render_error(status, message, _data = nil)
        render json: { errors: Array.wrap(message:) }, status:
      end
    end
  end
end
