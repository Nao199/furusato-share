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

end