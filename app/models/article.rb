class Article < ApplicationRecord
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :cities
  validates_presence_of :headline, :headline_short, :headline_short, :article_leader, :author_id, :categories, :cover_image, :article_body
  mount_uploader :cover_image, ImageUploader
  extend FriendlyId
  friendly_id :headline, use: [:slugged, :finders]
  acts_as_commentable

  def self.approved_articles
    Article.where(approved: true).order('created_at DESC')
  end

end
