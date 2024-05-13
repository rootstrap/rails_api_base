# frozen_string_literal: true

module API
  module V1
    class PasswordsController < DeviseTokenAuth::PasswordsController
      include API::Concerns::ActAsAPIRequest
      protect_from_forgery with: :null_session

      private

      def redirect_options
        { allow_other_host: true }
      end

      def render_error(status, message, _data = nil)
        render json: { errors: Array.wrap(message:) }, status:
      end
    end
  end
end
