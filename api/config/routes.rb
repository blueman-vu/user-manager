# frozen_string_literal: true

Rails.application.routes.draw do
  post 'auth/login', to: 'authentication#authenticate'
  get 'get_user', to: 'authentication#get_user'
  post 'signup', to: 'users#create'
  get '/users', to: 'users#index'
  get '/top_5', to: 'users#top_5'
  post '/block_user', to: 'users#block_user'
  post '/delete_user', to: 'users#delete_user'
  resources :posts, param: :alias_name
  put 'posts/:alias_name/like', to: 'posts#like'
end
