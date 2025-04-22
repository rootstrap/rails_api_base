# frozen_string_literal: true

module API
  module V1
    class RegistrationsController < DeviseTokenAuth::RegistrationsController
      include API::Concerns::ActAsAPIRequest
      include TelemetrySpan
      protect_from_forgery with: :null_session

      def create
        super do |resource|
          current_span.add_event(
            'New User created',
            attributes: {
              "new_user_created.id" => resource.id,
              "new_user_created.timestamp" => resource.created_at
            }
          )
        end
      end

      private

      def sign_up_params
        params.expect(user: %i[email password password_confirmation username first_name last_name])
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
