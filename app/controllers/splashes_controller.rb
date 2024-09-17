class SplashesController < ApplicationController
  # indexアクションの認証をスキップ
  skip_before_action :check_user_authentication, only: [:index]

  def index
    # ログイン済みユーザーをホームページにリダイレクト
    redirect_to root_path if user_signed_in?
    # 未ログインの場合、デフォルトでindex.html.erbを表示
  end
end