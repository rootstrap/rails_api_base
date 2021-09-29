# frozen_string_literal: true

module Api
  module Concerns
    module Jsonapi
      extend ActiveSupport::Concern

      included do
        include JSONAPI::Deserialization
        include JSONAPI::Errors
        include JSONAPI::Fetching
        include JSONAPI::Pagination
      end

      # +permitted_include+
      #
      # It allows the implementation of https://jsonapi.org/format/#document-compound-documents and
      # https://jsonapi.org/format/#fetching-includes.
      #
      # Usage:
      #
      #       def index
      #         render jsonapi: SomeModel.all, include: permitted_include
      #       end
      #
      #       private
      #
      #       def permitted_inclusions
      #         ['one_association', 'another_association']
      #       end

      def permitted_include
        return '' unless permitted_inclusions && include_params

        include_params.split(',') & permitted_inclusions
      end

      private

      def jsonapi_serializer_params
        {
          current_user: current_user
        }
      end

      def include_params
        params.permit(:include)[:include]
      end

      # To provide a different naming scheme implement the jsonapi_serializer_class method in your
      # resource or application controller.
      #
      #     def jsonapi_serializer_class(resource, is_collection)
      #       JSONAPI::Rails.serializer_class(resource, is_collection)
      #     rescue NameError
      #       # your serializer class naming implementation
      #     end
    end
  end
end
