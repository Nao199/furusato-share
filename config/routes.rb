Rails.application.routes.draw do
  # ユーザー認証のためのDeviseルーティング
  devise_for :users

  # アプリケーションのルートパスを設定
  root to: 'foods#index'

  # 食品関連のリソースルーティング
  resources :foods do
    collection do
      get 'search' # 食品検索のルート
    end
  end

  resources :transactions, only: [] do
    member do
      post 'reserve'           # 食品予約アクション
      post 'complete_transaction' # 取引完了アクション
    end
  end

  # スプラッシュ画面用のルーティング
  resources :splashes, only: [:index]

  # ユーザープロフィール表示用のルーティング
  resources :users, only: [:show]

  # ポイント表示用のルーティング
  resources :points, only: [:index]
end