Rails.application.routes.draw do

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resource :location, only: [:show, :update]
      resource :password, only: [:update]
      resource :profile, only: [:show, :update]
      resource :session, only: [:create, :destroy]
      resources :alerts, only: [:create]
    end
  end

  get 'auth/edit', to: redirect('/users')
  devise_for :users, path: 'auth', controllers: {
    registrations: 'users/registrations'
  }

  post 'pusher/auth', to: 'pusher#auth'
  get 'pusher/channels', to: 'pusher#channels'

  resource :dashboard
  resources :users, except: [:edit, :update]
  scope module: 'users' do
    resources :profiles, only: [:update]
    resources :locations, only: [:update]
    resources :emails, only: [:update]
    resources :passwords, only: [:update]
  end

  resources :alerts

  root 'pages#index'
end
