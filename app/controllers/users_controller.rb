class UsersController < ApplicationController

  def show
    @user = User.find_by(id: params[:id])
    @nickname = current_user.nickname
    @foods = current_user.foods
    @provided_foods = @user.foods.order(created_at: :desc)
    @total_points = calculate_total_points(@user)
    @share_count = @user.share_count
    @receive_count = @user.points.where(point_type: -1).count
    @title = determine_title(@total_points)
    @provision_count = @user.share_count
    @transactions = Transaction.where(provider: @user).or(Transaction.where(receiver: @user))
    .order(created_at: :desc).limit(10)
    # calculate_progress
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
      "エコフレンドリー・ルーキー"
    when 4..6
      "コミュニティ・ハーモナイザー"
    when 7..9
      "サステナブル・インフルエンサー"
    else
      "エコ・コミュニティ・チャンピオン"
    end
  end

  # def calculate_progress
  #   titles = [
  #     { name: "エコフレンドリー・ルーキー", max: 3 },
  #     { name: "コミュニティ・ハーモナイザー", max: 6 },
  #     { name: "サステナブル・インフルエンサー", max: 9 },
  #     { name: "エコ・コミュニティ・チャンピオン", max: Float::INFINITY }
  #   ]
  
  #   current_title = titles.find { |t| @total_points <= t[:max] }
  #   next_title = titles[titles.index(current_title) + 1]
  
  #   if next_title
  #     @points_for_next_title = next_title[:max] - @total_points
  #     @progress_percentage = ((@total_points - current_title[:max].to_f) / (next_title[:max] - current_title[:max])) * 100
  #   else
  #     @points_for_next_title = 0
  #     @progress_percentage = 100
  #   end
  
  #   @max_points = next_title ? next_title[:max] : current_title[:max]
  # end
end
