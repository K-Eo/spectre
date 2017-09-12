Rails.application.routes.draw do

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resource :auth, only: [:create, :destroy]
      resource :user do
        patch 'update_password', on: :collection
      end
    end
  end

  devise_for :users, path: 'user', controllers: {
    registrations: 'users/registrations'
  }

  resource :dashboard
  resources :workers, except: [:show, :edit, :update, :new] do
    member do
      get 'profile'
      patch 'profile', to: 'workers#update_profile'
      get 'settings'
      get 'account'
      patch 'account', to: 'workers@update_account'
      patch 'geo', to: 'workers#update_geo'
    end
  end

  root 'pages#index'
end
