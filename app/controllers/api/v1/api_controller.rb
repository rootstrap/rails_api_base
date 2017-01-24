# encoding: utf-8

module Api
  module V1
    class ApiController < ApplicationController
      skip_before_action :verify_authenticity_token, if: :json_request?

      include DeviseTokenAuth::Concerns::SetUserByToken

      before_action :authenticate_user!, except: :status
      before_action :skip_session_storage

      layout false
      respond_to :json

      rescue_from ActiveRecord::RecordNotFound,        with: :render_not_found
      rescue_from ActiveRecord::RecordInvalid,         with: :render_record_invalid
      rescue_from ActionController::RoutingError,      with: :render_not_found
      rescue_from ActionController::UnknownController, with: :render_not_found
      rescue_from AbstractController::ActionNotFound,  with: :render_not_found

      def status
        render json: { online: true }
      end

      def render_forbidden_access(exception)
        logger.info(exception) # for logging
        render json: { error: 'Not Authorized' }, status: :forbidden
      end

      def render_not_found(exception)
        logger.info(exception) # for logging
        render json: { error: "Couldn't find the record" }, status: :not_found
      end

      def render_record_invalid(exception)
        logger.info(exception) # for logging
        render json: { errors: exception.record.errors.as_json }, status: :bad_request
      end

      private

      def json_request?
        request.format.json?
      end

      def skip_session_storage
        # Devise stores the cookie by default, so in api requests, it is disabled
        # http://stackoverflow.com/a/12205114/2394842
        request.session_options[:skip] = true
      end
    end
  end
end
