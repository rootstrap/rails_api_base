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

class Setting < ApplicationRecord
  validates :key, uniqueness: true, presence: true
end
