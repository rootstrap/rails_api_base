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

FactoryBot.define do
  factory :setting do
    key   { 'key' }
    value { 'value' }

    factory :setting_version do
      key   { 'min_version' }
      value { '0.0' }
    end
  end
end
