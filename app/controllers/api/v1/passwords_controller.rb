# encoding: utf-8

module Api
  module V1
    class PasswordsController < DeviseTokenAuth::PasswordsController
      protect_from_forgery with: :exception
      skip_before_filter :verify_authenticity_token, if: :json_request?

      private

      def json_request?
        request.format.json?
      end
    end
  end
end
