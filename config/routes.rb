Rails.application.routes.draw do

  root "top#index"
  get "about" => "top#about", as: "about"
  get "contact" => "top#contact"
  get "/signup", to: "members#new"
  post "/signup", to: "members#create"
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  resources :members do
    resources :entries, only: [:index]
    get :following, :followers, on: :member
  end

  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :articles, only: [:index, :show]
  resources :relationships,       only: [:create, :destroy]
  resources :entries do
    patch :like, :unlike, on: :member
    get :voted, on: :collection
    resources :images, controller: "entry_images" do
      patch :move_higher, :move_lower, on: :member
    end
  end

  namespace :admin do
    root to: "top#index"
    resources :members
    resources :articles
  end
end
