module Api
  module V1
    class SettingsController < Api::V1::ApiController
      skip_before_action :authenticate_user!
      skip_after_action :verify_authorized, :verify_policy_scoped

      def must_update
        return head(:not_found) unless setting

        render jsonapi: setting
      end

      private

      def setting
        Setting.find_by(key: 'min_version')
      end

      def jsonapi_serializer_params
        super.merge(
          current_version: Gem::Version.new(params[:device_version] || '')
        )
      end
    end
  end
end
