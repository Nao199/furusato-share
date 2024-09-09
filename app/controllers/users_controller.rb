class UsersController < ApplicationController
  def show
    @user = User.find_by(id: params[:id])
    @nickname = current_user.nickname
    @foods = current_user.foods
    @total_points = calculate_total_points(@user)
    @share_count = @user.share_count
    @receive_count = @user.points.where(point_type: -1).count
    @title = determine_title(@total_points)
  end

  private

  def calculate_total_points(user)
    initial_points = 3
    shared_points = user.share_count
    received_points = user.points.where(point_type: -1).count
    initial_points + shared_points - received_points
  end

  def determine_title(points)
    case points
    when 0..3
      "おすそ分け初心者"
    when 4..9
      "おすそ分けフレンド"
    when 10..19
      "おすそ分けマスター"
    else
      "おすそ分けレジェンド"
    end
  end
end
