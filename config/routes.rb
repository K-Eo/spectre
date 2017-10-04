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

  resource :dashboard
  resource :channels
  resources :alerts
  resources :users, except: [:edit, :update] do
    namespace :permissions do
      resource :monitor, only: [:update, :destroy]
      resource :alert, only: [:update, :destroy]
    end
  end

  scope module: 'users' do
    resources :profiles, only: [:update]
    resources :locations, only: [:update]
    resources :emails, only: [:update]
    resources :passwords, only: [:update]
  end


  root 'pages#index'
end
