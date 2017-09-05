Rails.application.routes.draw do

  devise_for :users, path: 'user', controllers: {
    registrations: 'users/registrations'
  }

  resource :dashboard
  resources :workers

  root 'pages#index'
end
