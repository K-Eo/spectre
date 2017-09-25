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

  devise_for :users, path: 'auth', controllers: {
    registrations: 'users/registrations'
  }

  resource :dashboard
  resources :users, except: [:edit, :update]
  scope module: 'users' do
    resources :profiles, only: [:update]
    resources :location, only: [:update]
  end

  resources :alerts

  root 'pages#index'
end
