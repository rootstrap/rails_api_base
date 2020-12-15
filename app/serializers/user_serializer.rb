# frozen_string_literal: true

class UserSerializer < ApplicationSerializer
  attributes :email, :first_name, :last_name, :username, :created_at, :updated_at
end
