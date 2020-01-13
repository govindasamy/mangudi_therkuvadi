class City < ApplicationRecord
  has_and_belongs_to_many :articles
  validates_presence_of :name
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]
end
