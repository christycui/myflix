Myflix::Application.routes.draw do
  root to: 'pages#front'
  get '/register', to: 'users#new'
  get '/login', to: 'sessions#new'
  get '/logout', to: "sessions#destroy"
  get '/home', to: 'videos#index'
  get 'ui(/:action)', controller: 'ui'
  resources :videos, only: [:show] do
    collection do
      get '/search', to: 'videos#search'
    end
    resources :reviews, only: [:create]
  end
  resources :categories, only: [:show]
  resources :users, only: [:create, :show, :update]
  get "/people", to: "relationships#index"
  resources :relationships, only: [:create, :destroy]
  resources :sessions, only: [:create]
  get "/my_queue", to: "queue_items#index"
  resources :queue_items, only: [:create, :destroy]
  post "/update_queue", to: "queue_items#update_queue"
  get '/forgot_password', to: "password_reset#enter_email"
  post '/confirm_password_reset', to: "password_reset#confirm_password_reset"
  get '/enter_new_password', to: "password_reset#enter_new_password"
  post '/password_reset', to: "password_reset#reset_password"
  get '/invalid_token', to: "pages#invalid_token"

  resources :invitations, only: [:new, :create]
end
