# frozen_string_literal: true

module API
  module V1
    class APIController < ActionController::API
      include API::Concerns::ActAsAPIRequest
      include Pundit::Authorization
      include DeviseTokenAuth::Concerns::SetUserByToken

      before_action :authenticate_user!
      before_action :set_impersonation_header!

      after_action :verify_authorized, except: :index
      after_action :verify_policy_scoped, only: :index

      rescue_from ActiveRecord::RecordNotFound,        with: :render_not_found
      rescue_from ActiveRecord::RecordInvalid,         with: :render_record_invalid
      rescue_from ActionController::ParameterMissing,  with: :render_parameter_missing

      private

      def set_impersonation_header!
        token = current_user&.tokens&.find do |_token, attr|
          DeviseTokenAuth::TokenFactory.token_hash_is_token?(attr['token'], request.headers['Access-Token'])
        end

        response.headers['impersonate'] = true if token&.key?('impersonated_by')
      end

      def render_not_found(exception)
        logger.info { exception } # for logging
        render json: { error: I18n.t('api.errors.not_found') }, status: :not_found
      end

      def render_record_invalid(exception)
        logger.info { exception } # for logging
        render json: { errors: exception.record.errors.as_json }, status: :bad_request
      end

      def render_parameter_missing(exception)
        logger.info { exception } # for logging
        render json: { error: I18n.t('api.errors.missing_param') }, status: :unprocessable_entity
      end
    end
  end
end
