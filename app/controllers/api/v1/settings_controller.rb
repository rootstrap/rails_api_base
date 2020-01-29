module Api
  module V1
    class SettingsController < Api::V1::ApiController
      skip_before_action :authenticate_user!

      def must_update
        current_version = Gem::Version.new(params[:device_version])
        min_version = version ? Gem::Version.new(version) : Gem::Version.new('0.0.0')
        must_update = min_version > current_version
        render json: { 'must_update': must_update }
      end

      private

      def version
        Setting.find_by(key: 'min_version').try(:value)
      end
    end
  end
end
