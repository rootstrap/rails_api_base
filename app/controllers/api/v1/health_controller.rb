# frozen_string_literal: true

module API
  module V1
    class HealthController < API::V1::APIController
      skip_before_action :authenticate_user!
      skip_after_action :verify_authorized

      def get_delayed_jobs
        total_count = Delayed::Job.count
        if total_count > 0
          return render json: { count: total_count, oldest: Delayed::Job.order(:created_at).first.created_at }
        render json: { msg: 'No delayed jobs found' }
      end

      def status
        render json: { online: true }
      end
    end
  end
end
