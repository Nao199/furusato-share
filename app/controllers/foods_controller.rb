class FoodsController < ApplicationController
  before_action :set_food, only: [:show, :edit, :update, :destroy, :reserve, :complete_transaction]
  before_action :authenticate_user!, except: [:index]
  before_action :check_food_owner, only: [:edit, :update]

  def index
    @foods = Food.all
    if params[:category_id].present?
      @foods = @foods.where(category_id: params[:category_id])
    elsif params[:furusato_id].present?
      @foods = @foods.where(furusato_id: params[:furusato_id])
    elsif params[:furusato_ids].present?
      @foods = @foods.where(furusato_id: params[:furusato_ids])
    end

    @foods = @foods.order(created_at: :desc)
  end

  def new
    @food = Food.new
  end
  
  def edit
  end

  def update
    if @food.update(food_params)
      redirect_to @food, notice: '食材情報が更新されました。'
    else
      render :edit
    end
  end

  def create
    @food = Food.new(food_params)
    if @food.save
      redirect_to foods_path
    else
      @foods = Food.all
      render :index
    end
  end

  def destroy
    food = Food.find(params[:id])
    food.destroy
    redirect_to root_path
  end

  def search
    @foods = Food.search(params[:keyword])
    render :index
  end

  def show
    @food = Food.find(params[:id])
  end

  def reserve
    if @food.user_id != current_user.id && @food.status == '利用可能'
      ActiveRecord::Base.transaction do
        @food.update!(status: '予約済み')
        Transaction.create!(
          food: @food,
          provider: @food.user,
          receiver: current_user,
          status: '保留中'
        )
      end
      redirect_to root_path, notice: '食材の予約が完了しました。'
    else
      redirect_to root_path, alert: '食材の予約ができませんでした。'
    end
  rescue ActiveRecord::RecordInvalid
    redirect_to root_path, alert: '予約処理中にエラーが発生しました。'
  end

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
          @food.update!(status: :共有済み)
          @transaction.update!(status: :完了)
  
          # ポイントの付与（提供者に1ポイント、受取者に-1ポイント）
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
  
          # ユーザーの統計情報を更新
          provider.increment!(:share_count)
          receiver.increment!(:receive_count)
  
          # おすそわけポイントの更新
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
  def food_params
    params.require(:food).permit(:image, :name, :description, :quantity, :expiration_date, :allergen_info, :category_id, :furusato_id, :status, :available_from, :available_until, :pickup_location_id,).merge(user_id: current_user.id)
  end

  def set_food
    @food = Food.find(params[:id])
  end

  def check_food_owner
    unless current_user == @food.user && @food.status == '利用可能'
      redirect_to root_path, alert: 'この操作は許可されていません。'
    end
  end

end
