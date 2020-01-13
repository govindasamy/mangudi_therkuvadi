class Category < ApplicationRecord
  has_and_belongs_to_many :articles
  validates_presence_of :name
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  def has_parent?
    self.parent_id.present? ? true : false
  end

  def children
    Category.where(parent_id: self.id)
  end

  def self.parent_ctegories
    Category.where(parent_id: nil)
  end

end
