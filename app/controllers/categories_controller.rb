class CategoriesController < ApplicationController
  before_action :set_category, only: [:show]

  # GET /categories
  # GET /categories.json
  # def index
  #   @categories = Category.all
  # end

  # GET /categories/1
  # GET /categories/1.json
  def show
    @articles = @category.articles.approved_articles
    @first_article = @articles.first
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.friendly.find(params[:id])
    end
end
