Rails.application.routes.draw do
  devise_for :users
  root to:'foods#index'

  resources :foods do
    member do
      post 'reserve'
      post 'complete_transaction'
    end    
    collection do
      get 'search'
    end
  end

  resources :splashes , only: [:index]
  resources :users, only: [:show]

end
