class Admin::Dashboard::CitiesController < Admin::Dashboard::BaseController
  before_action :set_city, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  # GET /cities
  # GET /cities.json
  def index
    length, page, search_query = pagination_params(params)
    @cities = if search_query.present?
                    City.where(["Lower(name) LIKE ?", "%#{search_query.downcase}%"]).order("created_at DESC")
                  else
                    City.order("created_at DESC")
                  end
    @cities = @cities.paginate(:page => page, :per_page => length)
    respond_to do |format|
      format.html # index.html.erb
      format.js
      count = @cities.count
      format.json { render json: {draw: params[:draw], recordsTotal: count, recordsFiltered: count,
                                  data: @cities.collect{|p| {"Name" => p.name, "Created at" => p.created_at.strftime("%m/%d/%Y"), Actions: p.id}}}.to_json }
    end
  end

  # GET /cities/1
  # GET /cities/1.json
  def show
  end

  # GET /cities/new
  def new
    @city = City.new
  end

  # GET /cities/1/edit
  def edit
  end

  # POST /cities
  # POST /cities.json
  def create
    @city = City.new(city_params)

    respond_to do |format|
      if @city.save
        format.html { redirect_to admin_dashboard_cities_path, notice: 'city was successfully created.' }
        format.json { render :show, status: :created, location: @city }
      else
        format.html { render :new }
        format.json { render json: @city.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cities/1
  # PATCH/PUT /cities/1.json
  def update
    respond_to do |format|
      if @city.update(city_params)
        format.html { redirect_to admin_dashboard_cities_path, notice: 'city was successfully updated.' }
        format.json { render :show, status: :ok, location: @city }
      else
        format.html { render :edit }
        format.json { render json: @city.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cities/1
  # DELETE /cities/1.json
  def destroy
    @city.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_city
      @city = City.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def city_params
      params.require(:city).permit(:name)
    end
end
