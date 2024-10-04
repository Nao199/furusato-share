class FoodsController < ApplicationController
  before_action :set_food, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index]
  before_action :check_food_owner, only: [:edit, :update]

  # 食品一覧を表示
  def index
    @foods = Food.all

    # カテゴリー、ふるさとIDでフィルタリング
    if params[:category_id].present?
      @foods = @foods.where(category_id: params[:category_id])
    elsif params[:furusato_id].present?
      @foods = @foods.where(furusato_id: params[:furusato_id])
    elsif params[:furusato_ids].present?
      @foods = @foods.where(furusato_id: params[:furusato_ids])
    end

    # 作成日時の降順で並べ替え
    @foods = @foods.order(created_at: :desc)
  end

  # 新規食品作成フォームを表示
  def new
    @food = Food.new
  end
  
  # 食品編集フォームを表示
  def edit; end

  # 食品情報を更新
  def update
    if @food.update(food_params)
      redirect_to @food, notice: '食材情報が更新されました。'
    else
      render :edit
    end
  end

  # 新規食品を作成
  def create
    @food = Food.new(food_params)
    if @food.save
      redirect_to foods_path
    else
      @foods = Food.all
      render :index
    end
  end

  # 食品を削除
  def destroy
    food = Food.find(params[:id])
    food.destroy
    redirect_to root_path
  end

  # キーワードで食品を検索
  def search
    @foods = Food.search(params[:keyword])
    render :index
  end

  # 食品詳細を表示（ポイント計算は別コントローラで行う）
  def show 
    @food = Food.find(params[:id])
    # ポイント計算は別のコントローラで行うため削除。
  end
  
private
  
# 許可されたパラメータを定義  
def food_params  
params.require(:food).permit(:image, :name, :description, :quantity, :expiration_date, :allergen_info, :category_id, :furusato_id, :status, :available_from, :available_until, :pickup_location_id).merge(user_id: current_user.id)  
end  

# 現在のユーザーが食品の所有者であることを確認  
def check_food_owner  
  unless current_user == @food.user && @food.status == '利用可能'  
  redirect_to root_path, alert: 'この操作は許可されていません。'  
  end
end

def set_food 
  @food = Food.find(params[:id]) 
end 
      
end