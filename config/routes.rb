Rails.application.routes.draw do
  root 'tasks#index'

  # タスク機能
  resources :tasks

  # ログイン機能
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
end
