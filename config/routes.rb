Rails.application.routes.draw do

  resources :terminals do
    member do
      post 'send_token'
    end
    collection do
      post 'pair_device'
    end
  end

  root 'pages#index'
end
