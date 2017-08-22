Rails.application.routes.draw do

  devise_for :users

  # Scope routes for domain
  scope(path: ':subdomain', constraints: { subdomain: /[\w\-]+/ }) do

    resources :terminals do
      member do
        post 'send_token'
        # Unpair device from web
        delete 'pair_device', to:'terminals#unpair_device_web'
      end
      collection do
        post 'pair_device', to: 'terminals#pair_device'
        # Unpair device from API
        delete 'pair_device', to: 'terminals#unpair_device'
      end
    end

  end

  root 'pages#index'
end
