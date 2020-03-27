# == Schema Information
#
# Table name: settings
#
#  id    :integer          not null, primary key
#  key   :string
#  value :string
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
