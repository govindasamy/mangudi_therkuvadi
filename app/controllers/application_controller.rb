class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :store_user_location!, if: :storable_location?
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to '/', :alert => exception.message
  end
  # def current_ability
  #   @current_ability ||= Ability.new(current_aap_user)
  # end
  def pagination_params(params)
    start = params[:start].to_i
    length = params[:length].to_i
    length = 10 if length == 0
    page = start == 0 ? 1 : (start / length + 1)

    search_query = params[:search] && params[:search][:value]
    [length, page, search_query]
  end

  private

  def after_sign_out_path_for(resource_or_scope)
      "/"
  end

  def after_sign_in_path_for(resource_or_scope)
    stored_location_for(resource_or_scope) || super
  end

  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def store_user_location!
    # :user is the scope we are authenticating
    store_location_for(:user, request.fullpath)
  end

  protected
   def configure_permitted_parameters
     devise_parameter_sanitizer.permit(:sign_up) do |user_params|
       user_params.permit(
         :username,
         :email,
         :password,
         :password_confirmation
         )
     end
   end
end
