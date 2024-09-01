Rails.application.routes.draw do
  root "static_pages#home"
  get "/help",   to:'static_pages#help'
  get "/about",  to:'static_pages#about'
  get "/contact",to:'static_pages#contact'
  get "/signup" ,to:"users#new"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout",to:"sessions#destroy"
  post "/likes/:micropost_id/create", to:"likes#create", as: 'create_like'
  delete "/likes/:micropost_id/delete", to:"likes#destroy", as: 'delete_like'
  resources :users do
    member do
      get :following, :followers
    end
    collection do
      get :search
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts, only:[:create,:destroy,:show] do
    member do
      get :most_liked
      get :newest
    end
  end
  resources :relationships,       only: [:create, :destroy]
  resources :blocks, only: [:create, :destroy]
end
