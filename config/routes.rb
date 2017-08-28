Rails.application.routes.draw do

  devise_for :users, path: 'user', controllers: {
    registrations: 'users/registrations'
  }

  resources :terminals do
    member do
      post 'send_token'
      delete 'pair_device', to: 'terminals#unpair_device'
    end
  end

  namespace :device do
    resources :pairings, only: [:create, :destroy], param: :token
  end

  root 'pages#index'
end
