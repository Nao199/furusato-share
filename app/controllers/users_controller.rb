class UsersController < ApplicationController
  # ユーザーの詳細情報を表示するアクション
  def show
    # URLパラメータからユーザーを検索
    @user = User.find_by(id: params[:id])
    # 現在ログインしているユーザーのニックネームを取得
    @nickname = current_user.nickname
    # 現在のユーザーが登録した食品を取得
    @foods = current_user.foods
    # 表示対象のユーザーが提供した食品を新しい順に取得
    @provided_foods = @user.foods.order(created_at: :desc)
    # ユーザーの総ポイントを計算
    @total_points = calculate_total_points(@user)
    # ユーザーの食品共有回数を取得
    @share_count = @user.share_count
    # ユーザーが食品を受け取った回数を計算
    @receive_count = @user.points.where(point_type: -1).count
    # ユーザーの現在のタイトルを決定
    @title = determine_title(@total_points)
    # 食品提供回数（共有回数と同じ）
    @provision_count = @user.share_count
    # ユーザーの最新10件の取引履歴を取得
    @transactions = Transaction.where(provider: @user).or(Transaction.where(receiver: @user))
                               .order(created_at: :desc).limit(10)
    # 進捗計算のメソッド（現在はコメントアウト）
    # calculate_progress
  end

  private

  # ユーザーの総ポイントを計算するメソッド
  def calculate_total_points(user)
    initial_points = 3  # 初期ポイント
    shared_points = user.share_count  # 共有で得たポイント
    received_points = user.points.where(point_type: -1).count  # 受け取りで使用したポイント
    initial_points + shared_points - received_points  # 総ポイントの計算
  end

  # ポイントに基づいてユーザーのタイトルを決定するメソッド
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

  # ユーザーの進捗状況を計算するメソッド（現在は使用されていない）
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