# frozen_string_literal: true

module API
  module V1
    class ImpersonationsController < API::V1::APIController
      skip_before_action :authenticate_user!
      skip_after_action :verify_authorized

      def create
        response.headers.merge!(
          Impersonation::Authenticator.new(
            params[:auth_encrypted]
          ).build_auth_headers!
        ).merge!(impersonated: true)
      end
    end
  end
end
