class Admin::Dashboard::UsersController < Admin::Dashboard::BaseController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  def index
    length, page, search_query = pagination_params(params)
    @users = if search_query.present?
                    User.where(["Lower(username) LIKE ?", "%#{search_query.downcase}%"]).order("created_at DESC")
                  else
                    User.order("created_at DESC")
                  end
    @users = @users.paginate(:page => page, :per_page => length)
    respond_to do |format|
      format.html # index.html.erb
      format.js
      count = @users.count
      format.json { render json: {draw: params[:draw], recordsTotal: count, recordsFiltered: count,
                                  data: @users.collect{|p| {"Name" => p.username, "Role" => p.roles.present? ? p.roles.first.name : '', "Created at" => p.created_at.strftime("%m/%d/%Y"), Actions: p.id}}}.to_json }
    end
  end

  def new
    @user = User.new
  end

  def show
  end

  def create
    @user = User.new user_params
    if @user.save
      redirect_to admin_dashboard_users_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes user_params
      redirect_to admin_dashboard_users_path
    end
    flash[:notice] = "User Successfully Updated..."
  end

  def destroy
    @user.destroy
  end

  private

  def set_user
    @user = User.friendly.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :email, :password, role_ids:[])
  end

end
