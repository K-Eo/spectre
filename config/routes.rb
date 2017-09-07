Rails.application.routes.draw do

  devise_for :users, path: 'user', controllers: {
    registrations: 'users/registrations'
  }

  resource :dashboard
  resources :workers, except: [:show, :edit, :update, :new] do
    get 'profile', on: :member
    get 'settings', on: :member
    get 'account', on: :member
  end

  root 'pages#index'
end
