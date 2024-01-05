# frozen_string_literal: true

module API
  module V1
    class UsersController < API::V1::APIController
      skip_before_action :authenticate_user!
      skip_after_action :verify_authorized

      def create
        response.headers.merge!(user.build_auth_headers(token.token, token.client))
      end
    end
  end
end