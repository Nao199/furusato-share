class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_out_path_for(resource_or_scope)
    splashes_path 
  end

  private
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up,keys: [:nickname, :first_name, :name, :name_kana, :birth_date, :room_number, :allergies, :preferences, :share_count])
  end
end
