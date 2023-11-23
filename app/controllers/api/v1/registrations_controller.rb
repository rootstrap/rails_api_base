# frozen_string_literal: true

module API
  module V1
    class RegistrationsController < DeviseTokenAuth::RegistrationsController
      protect_from_forgery with: :exception, unless: :json_request?
      include API::Concerns::ActAsAPIRequest

      private

      def sign_up_params
        params.require(:user).permit(:email, :password, :password_confirmation,
                                     :username, :first_name, :last_name)
      end

      def render_create_success
        render :create
      end
    end
  end
end
