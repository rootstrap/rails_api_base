module Api
  module V1
    class SettingsController < Api::V1::ApiController
      skip_before_action :authenticate_user!
      skip_after_action :verify_authorized, :verify_policy_scoped

      def must_update
        current_version = Gem::Version.new(params[:device_version])
        min_version = Gem::Version.new(version || '0.0.0')
        must_update = min_version > current_version
        render json: { must_update: }
      end

      private

      def version
        Setting.find_by(key: 'min_version').try(:value)
      end
    end
  end
end
