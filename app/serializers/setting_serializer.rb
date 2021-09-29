# frozen_string_literal: true

# == Schema Information
#
# Table name: settings
#
#  id         :bigint           not null, primary key
#  key        :string           not null
#  value      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_settings_on_key  (key) UNIQUE
#
class SettingSerializer < ApplicationSerializer
  attributes :key, :value, :created_at
  attribute :must_update do |object, params|
    return if object.key != 'min_version'

    Gem::Version.new(object.value) > params[:current_version]
  end
end
