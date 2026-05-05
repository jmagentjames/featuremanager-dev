Rails.application.routes.draw do
  # Auth
  get "signup", to: "users#new", as: :signup
  post "signup", to: "users#create"

  resource :session, only: [:new, :create, :destroy]
  get "login", to: "sessions#new", as: :login
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy", as: :logout

  get "password/reset", to: "password_resets#new", as: :new_password_reset
  post "password/reset", to: "password_resets#create"
  get "password/reset/:token", to: "password_resets#edit", as: :edit_password_reset
  patch "password/reset/:token", to: "password_resets#update"

  get "password", to: "passwords#edit", as: :edit_password
  patch "password", to: "passwords#update"

  # Pages
  get "about", to: "about#show", as: :about

  # Messages (no GET for create — POST only)
  resources :messages, only: [:new, :create]

  # Admin
  namespace :admin do
    root "dashboard#index"
    resources :messages, only: [:index, :show]
  end

  # Health
  get "up" => "rails/health#show", as: :rails_health_check

  # Root
  root "home#index"
end
