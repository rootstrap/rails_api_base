# frozen_string_literal: true

class UserSerializer < ApplicationSerializer
  attributes :created_at,
             :email,
             :first_name,
             :id,
             :last_name,
             :provider,
             :uid,
             :updated_at,
             :username
end
