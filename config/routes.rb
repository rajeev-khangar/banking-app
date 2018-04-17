Rails.application.routes.draw do
  devise_for :managers
	resources :users
	root "users#index"
end
