Rails.application.routes.draw do
  namespace :sandbox do
    get 'devices', to: 'device#index'
    post 'devices', to: 'device#pairing'
  end

  resources :terminals do
    member do
      post 'send_token'
    end
  end
  root 'pages#index'
end
