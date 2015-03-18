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
  resources :users, only: [:create]
  resources :sessions, only: [:create]
  get "/my_queue", to: "queue_items#index"
  resources :queue_items, only: [:create]

end
