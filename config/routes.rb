Rails.application.routes.draw do

  devise_for :users, path: 'user', controllers: {
    registrations: 'users/registrations'
  }

  resource :dashboard
  root 'pages#index'
end
