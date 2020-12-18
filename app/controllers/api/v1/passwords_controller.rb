module Api
  module V1
    class PasswordsController < DeviseTokenAuth::PasswordsController
      protect_from_forgery with: :exception
      include Api::Concerns::ActAsApiRequest
    end
  end
end
