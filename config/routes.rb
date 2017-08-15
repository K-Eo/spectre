Rails.application.routes.draw do
  resources :terminals do
    member do
      post 'send_token'
    end
  end
  root 'pages#index'
end
