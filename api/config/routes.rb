# frozen_string_literal: true

Rails.application.routes.draw do
  post 'auth/login', to: 'authentication#authenticate'
  post 'signup', to: 'users#create'
  get '/users', to: 'users#index'
  post '/block_user', to: 'users#block_user'
end
