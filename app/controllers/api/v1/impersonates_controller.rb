# frozen_string_literal: true

module API
  module V1
    class ImpersonatesController < API::V1::APIController
      skip_before_action :authenticate_user!
      skip_after_action :verify_authorized

      def create
        response.headers.merge!(
          Impersonation::Authenticator.new(
            params[:auth_enc]
          ).build_auth_headers!
        )
      end
    end
  end
end
