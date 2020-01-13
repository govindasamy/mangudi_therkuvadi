class ArticlesController < ApplicationController
  before_action :set_article, only: [:show]

  # GET /articles
  # GET /articles.json
  def index
    @articles = Article.approved_articles
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
    @new_comment = Comment.build_from(@article, @article.id, "")
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.friendly.find(params[:id])
    end
end
