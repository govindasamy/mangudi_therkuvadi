class HomeController < ApplicationController
  def index
    @articles = Article.approved_articles.limit(12)
    @recent_articles = @articles.limit(3)
    @articles = @articles - @recent_articles
  end
end
