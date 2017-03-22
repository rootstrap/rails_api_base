module Api
  module Concerns
    module ActAsApiRequest
      extend ActiveSupport::Concern

      included do
        skip_before_action :verify_authenticity_token
        before_action :skip_session_storage
        before_action :check_json_request
      end

      def check_json_request
        head :not_acceptable unless request.content_type =~ /json/
      end

      def skip_session_storage
        # Devise stores the cookie by default, so in api requests, it is disabled
        # http://stackoverflow.com/a/12205114/2394842
        request.session_options[:skip] = true
      end
    end
  end
end
