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
      patch 'update_profile'
      get 'settings'
      get 'account'
      patch 'update_account'
    end
  end

  root 'pages#index'
end
