Rails.application.routes.draw do
  # ユーザー認証のためのDeviseルーティング
  devise_for :users

  # アプリケーションのルートパスを設定
  root to: 'foods#index'

  # 食品関連のリソースルーティング
  resources :foods do
    member do
      # 個別の食品に対する予約アクション
      post 'reserve'
      # 取引完了アクション
      post 'complete_transaction'
    end    
    collection do
      # 食品検索アクション
      get 'search'
    end
  end

  # スプラッシュ画面用のルーティング
  resources :splashes, only: [:index]

  # ユーザープロフィール表示用のルーティング
  resources :users, only: [:show]
end