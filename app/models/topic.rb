class Topic < ApplicationRecord
  validates :name, presence: true
  validates :image, presence: true
end
