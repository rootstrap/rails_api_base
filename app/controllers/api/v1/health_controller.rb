# frozen_string_literal: true

module Api
  module V1
    class HealthController < Api::V1::ApiController
      skip_before_action :authenticate_user!
      skip_after_action :verify_authorized

      def status
        render json: { online: true }
      end
    end
  end
end
