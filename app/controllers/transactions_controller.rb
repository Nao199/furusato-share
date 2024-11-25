class TransactionsController < ApplicationController
  before_action :set_food, only: [:reserve, :complete_transaction]
  before_action :authenticate_user! # ユーザー認証を要求

  # 食品を予約
  def reserve
    if @food.user_id != current_user.id && @food.status == '利用可能'
      ActiveRecord::Base.transaction do
        @food.update!(status: '予約済み')
        Transaction.create!(
          food: @food,
          provider: @food.user,
          receiver: current_user,
          status: :pending  # シンボルを使用
        )
      end
      redirect_to root_path, notice: '食材の予約が完了しました。'
    else
      redirect_to root_path, alert: '食材の予約ができませんでした。'
    end
  rescue ActiveRecord::RecordInvalid
    redirect_to root_path, alert: '予約処理中にエラーが発生しました。'
  end

  # 取引を完了
  def complete_transaction
    Rails.logger.debug "Food ID: #{@food.id}"
    Rails.logger.debug "Current food status: #{@food.status}"
    
    @transaction = Transaction.find_by(food: @food, status: :保留中)
    Rails.logger.debug "Pending transaction: #{@transaction&.inspect}"
    
    if @transaction&.receiver != current_user
      Rails.logger.warn "Unauthorized attempt to complete transaction for food #{@food.id} by user #{current_user.id}"
      redirect_to root_path, alert: '予約者のみが取引を完了できます。'
    elsif @food.status != '予約済み'
      Rails.logger.warn "Attempt to complete transaction for non-reserved food #{@food.id}"
      redirect_to root_path, alert: '予約済みの食材のみ取引完了できます。'
    elsif @transaction
      provider = @transaction.provider
      receiver = @transaction.receiver
  
      Food.transaction do
        begin
          # 食品状態と取引状態を更新
          @food.update!(status: :共有済み)
          @transaction.update!(status: :完了)
  
          # ポイントを付与
          Point.create!(
            food_transaction: @transaction,
            point_type: 1,
            user: provider,
            amount: 1
          )
          Point.create!(
            food_transaction: @transaction,
            point_type: -1,
            user: receiver,
            amount: 1
          )
  
          # ユーザー統計を更新
          provider.increment!(:share_count)
          receiver.increment!(:receive_count)
  
          # おすそわけポイントを更新
          provider.update_osusowake_point
          receiver.update_osusowake_point
  
          Rails.logger.info "Transaction completed successfully for food #{@food.id}"
          redirect_to root_path, notice: '取引が完了しました。'
        rescue => e
          Rails.logger.error "Transaction failed: #{e.message}"
          Rails.logger.error e.backtrace.join("\n")
          redirect_to root_path, alert: '取引の完了中にエラーが発生しました。'
        end
      end
    else
      Rails.logger.warn "No pending transaction found for food #{@food.id}"
      redirect_to root_path, alert: '保留中の取引が見つかりません。'
    end
  end

  private

  # 指定されたIDの食品を取得（FoodsControllerから移動）
  def set_food
    @food = Food.find(params[:id])
  end

end