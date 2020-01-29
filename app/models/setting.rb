# == Schema Information
#
# Table name: settings
#
#  id    :integer          not null, primary key
#  key   :string
#  value :string
#

class Setting < ApplicationRecord
  validates :key, uniqueness: true, presence: true
end
