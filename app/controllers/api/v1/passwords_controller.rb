# encoding: utf-8

module Api
  module V1
    class PasswordsController < DeviseTokenAuth::PasswordsController
      protect_from_forgery with: :null_session
    end
  end
end
