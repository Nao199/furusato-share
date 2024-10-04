class PointsController < ApplicationController
  before_action :authenticate_user! # ユーザー認証を要求

  # ユーザーの合計ポイントを表示
  def index
    @total_points = calculate_total_points(current_user)
  end

  # ポイントを計算するメソッド
  def calculate_total_points(user)
    initial_points = 3
    shared_points = user.share_count
    received_points = user.points.where(point_type: -1).count
    initial_points + shared_points - received_points
  end

  private

  # ユーザーのポイントをチェック
  def check_user_points(food)
    @total_points = calculate_total_points(current_user)
    if @total_points <= 0
      redirect_to food, alert: 'ポイントが不足しています。'
    end
  end
end
