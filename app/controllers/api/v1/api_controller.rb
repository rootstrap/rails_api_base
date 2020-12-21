module Api
  module V1
    class ApiController < ActionController::API
      include Api::Concerns::Jsonapi
      include Pundit
      include DeviseTokenAuth::Concerns::SetUserByToken

      after_action :verify_authorized, except: :index
      after_action :verify_policy_scoped, only: :index

      before_action :authenticate_user!, except: :status
      skip_after_action :verify_authorized, only: :status

      def status
        head(:ok)
      end
    end
  end
end
