# frozen_string_literal: true

module ActiveStorage
  class Service
    class DiskWithHostService < ActiveStorage::Service::DiskService
      def url_options
        Rails.application.default_url_options
      end
    end
  end
end
