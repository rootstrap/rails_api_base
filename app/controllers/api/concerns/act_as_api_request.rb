module Api
  module Concerns
    module ActAsApiRequest
      extend ActiveSupport::Concern

      included do
        include Api::Concerns::Jsonapi
        skip_before_action :verify_authenticity_token
        before_action :skip_session_storage
        before_action :check_json_request
      end

      def check_json_request
        return if !request_with_body? || request_content_type.match?(/json/)

        head(:not_acceptable)
      end

      def skip_session_storage
        # Devise stores the cookie by default, so in api requests, it is disabled
        # http://stackoverflow.com/a/12205114/2394842
        request.session_options[:skip] = true
      end

      private

      def request_content_type
        request.content_type || ''
      end

      def request_with_body?
        request.post? || request.put? || request.patch?
      end
    end
  end
end
