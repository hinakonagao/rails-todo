Rails.application.routes.draw do
  get 'tasks/index'
  root 'tasks#index'

  # ログイン機能
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
end
