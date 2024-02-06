# frozen_string_literal: true

module API
  module V1
    class ImpersonationsController < API::V1::APIController
      skip_before_action :authenticate_user!
      skip_after_action :verify_authorized

      def create
        user, token = Impersonation::Authenticator.new(params[:auth]).authenticate!

        response.headers.merge!(
          user.build_auth_headers(token.token, token.client)
        ).merge!(
          Impersonation::Headers.new(user).build_impersonation_header
        )
      end
    end
  end
end
