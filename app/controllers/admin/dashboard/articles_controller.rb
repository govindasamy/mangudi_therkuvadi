class Admin::Dashboard::ArticlesController < Admin::Dashboard::BaseController
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  # GET /articles
  # GET /articles.json
  def index
    length, page, search_query = pagination_params(params)
    @articles = if search_query.present?
                    Article.where(["Lower(headline) LIKE ?", "%#{search_query.downcase}%"]).order("created_at DESC")
                  else
                    Article.order("created_at DESC")
                  end
    @articles = @articles.paginate(:page => page, :per_page => length)
    respond_to do |format|
      format.html # index.html.erb
      format.js
      count = @articles.count
      format.json { render json: {draw: params[:draw], recordsTotal: count, recordsFiltered: count,
                                  data: @articles.collect{|p| {"Headline" => p.headline, "State" => p.approved ? 'Published' : 'Unpublished', "Created at" => p.created_at.strftime("%m/%d/%Y"), Actions: p.id}}}.to_json }
    end
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = Article.new(article_params)

    #if User is admin
    if current_user.admin?
      @article.approved = true
    end

    respond_to do |format|
      if @article.save
        format.html { redirect_to admin_dashboard_articles_path, notice: 'Article was successfully created.' }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
    #if User is admin
    if current_user.admin?
      @article.approved = true
    end
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to admin_dashboard_articles_path, notice: 'Article was successfully updated.' }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
      params.require(:article).permit(:headline, :headline_short, :article_body, :approved, :author_id, :cover_image, :title_top, :article_leader, category_ids: [], city_ids: [])
    end
end
