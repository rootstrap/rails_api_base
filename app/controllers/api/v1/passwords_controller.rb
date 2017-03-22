# encoding: utf-8

module Api
  module V1
    class PasswordsController < DeviseTokenAuth::PasswordsController
      protect_from_forgery with: :exception
      include Concerns::ActAsApiRequest
    end
  end
end
