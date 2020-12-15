
# frozen_string_literal: true

class SettingSerializer < ApplicationSerializer
  attributes :key, :value, :created_at
  attribute :must_update do |object, params|
    return nil if object.key != 'min_version'

    Gem::Version.new(object.value) > params[:current_version]
  end
end
