class ApplicationController < ActionController::Base
  # 基本認証
  before_action :basic_auth
  # Deviseパラメータ設定
  before_action :configure_permitted_parameters, if: :devise_controller?
  # ユーザー認証チェック（new, create以外）
  before_action :check_user_authentication, except: [:new, :create]

  
  # サインアウト後のリダイレクト先
  def after_sign_out_path_for(resource_or_scope)
    splashes_path 
  end

  private

  # Devise許可パラメータ
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up,keys: [:nickname, :first_name, :name, :name_kana, :birth_date, :room_number, :allergies, :preferences, :share_count])
  end
  
  # 未サインインユーザーのリダイレクト
  def check_user_authentication
    unless user_signed_in?
      redirect_to splashes_path
    end
  end

  # HTTP基本認証
  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV["BASIC_AUTH_USER"] && password == ENV["BASIC_AUTH_PASSWORD"]
    end
  end
end