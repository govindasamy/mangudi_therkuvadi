class Admin::Dashboard::BaseController < ApplicationController
  before_action :authenticate_user!
  layout 'admin'
  def index
    if current_user.admin?
      redirect_to "/admin/dashboard/articles"
    elsif current_user.author?
      redirect_to "/authors/admin"
    else
      redirect_to "/"
    end
  end
end
