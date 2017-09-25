Rails.application.routes.draw do

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resource :session, only: [:create, :destroy]
      resource :profile, only: [:show, :update]
      resource :user do
        patch 'update_password', on: :collection
      end
      resources :alerts
    end
  end

  devise_for :users, path: 'auth', controllers: {
    registrations: 'users/registrations'
  }

  resource :dashboard
  resources :users, except: [:edit, :update] do
    member do
      patch 'profile'
      patch 'account'
      patch 'geo'
    end
  end

  resources :alerts

  root 'pages#index'
end
