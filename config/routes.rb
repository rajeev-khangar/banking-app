Rails.application.routes.draw do
  devise_for :managers
  resources :users do
    resources :statements 
    member do
      post :withdraw
      post :deposit
    end
  end
  root "users#index"
end
