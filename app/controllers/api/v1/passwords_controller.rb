# encoding: utf-8

module Api
  module V1
    class PasswordsController < DeviseTokenAuth::PasswordsController
      include Concerns::ActAsApiRequest
      protect_from_forgery with: :exception
    end
  end
end
