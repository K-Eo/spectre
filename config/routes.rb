Rails.application.routes.draw do

  devise_for :users, path: 'user', controllers: {
    registrations: 'users/registrations'
  }

  resource :dashboard
  resources :workers, except: [:show, :edit, :update, :new] do
    member do
      get 'profile'
      put 'update_profile'
      get 'settings'
      get 'account'
      put 'update_account'
    end
  end

  root 'pages#index'
end
