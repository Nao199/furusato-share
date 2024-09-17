class FoodsharingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_food_sharing, only: [:show, :complete]

  # 新しい食品共有を作成
  def create
    @food_sharing = FoodSharing.new(food_sharing_params)
    if @food_sharing.save
      redirect_to @food_sharing, notice: '食品の共有が開始されました。'
    else
      render :new
    end
  end

  # 共有の詳細を表示
  def show
  end

  # 食品共有を完了する
  def complete
    if @food_sharing.can_complete?(current_user)
      ActiveRecord::Base.transaction do
        @food_sharing.complete!
        PointCalculator.add_points(@food_sharing.provider, 1)  # 提供者にポイントを追加
        PointCalculator.use_points(@food_sharing.receiver, 1)    # 受取人からポイントを使用
        @food_sharing.food.update!(status: :共有済み)            # 食品の状態を更新
      end
      redirect_to @food_sharing, notice: '食品の共有が完了しました。ポイントが更新されました。'
    else
      redirect_to @food_sharing, alert: 'この操作は許可されていません。'
    end
  rescue ActiveRecord::RecordInvalid
    redirect_to @food_sharing, alert: '共有の完了中にエラーが発生しました。'
  end

  private

  # 特定の食品共有を取得
  def set_food_sharing
    @food_sharing = FoodSharing.find(params[:id])
  end

  # 許可されたパラメータを定義
  def food_sharing_params
    params.require(:food_sharing).permit(:food_id, :receiver_id).merge(provider_id: current_user.id)
  end
end