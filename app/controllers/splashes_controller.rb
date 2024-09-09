class SplashesController < ApplicationController
  skip_before_action :check_user_authentication, only: [:index]
  def index
    if user_signed_in?
      redirect_to root_path
    end
  end
end
