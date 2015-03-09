Myflix::Application.routes.draw do
  root to: 'pages#front'
  get '/register', to: 'users#new'
  get '/login', to: 'sessions#new'
  get '/home', to: 'videos#index'
  get 'ui(/:action)', controller: 'ui'
  resources :videos, only: [:show] do
    collection do
      get '/search', to: 'videos#search'
    end
  end
  resources :categories, only: [:show]
  resources :users, only: [:create]
  resources :sessions, only: [:create]
  get '/logout', to: "sessions#destroy"
end
