class Admin::Dashboard::CategoriesController < Admin::Dashboard::BaseController
  before_action :set_category, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  # GET /categories
  # GET /categories.json
  def index
    length, page, search_query = pagination_params(params)
    @categories = if search_query.present?
                    Category.where(["Lower(name) LIKE ?", "%#{search_query.downcase}%"]).order("created_at DESC")
                  else
                    Category.order("created_at DESC")
                  end
    @categories = @categories.paginate(:page => page, :per_page => length)
    respond_to do |format|
      format.html # index.html.erb
      format.js
      count = @categories.count
      format.json { render json: {draw: params[:draw], recordsTotal: count, recordsFiltered: count,
                                  data: @categories.collect{|p| {"Name" => p.name, "Parent Category" => p.parent_id.present? ? Category.find(p.parent_id).name : '', "Created at" => p.created_at.strftime("%m/%d/%Y"), Actions: p.id}}}.to_json }
    end
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
  end

  # GET /categories/new
  def new
    @category = Category.new
  end

  # GET /categories/1/edit
  def edit
  end

  # POST /categories
  # POST /categories.json
  def create
    @category = Category.new(category_params)

    respond_to do |format|
      if @category.save
        format.html { redirect_to admin_dashboard_categories_path, notice: 'Category was successfully created.' }
        format.json { render :show, status: :created, location: @category }
      else
        format.html { render :new }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categories/1
  # PATCH/PUT /categories/1.json
  def update
    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to admin_dashboard_categories_path, notice: 'Category was successfully updated.' }
        format.json { render :show, status: :ok, location: @category }
      else
        format.html { render :edit }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    @category.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def category_params
      params.require(:category).permit(:name, :parent_id)
    end
end
