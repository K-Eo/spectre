Rails.application.routes.draw do

  devise_for :users

  # Scope routes for domain
  scope(path: ':organization', constraints: { organization: /[\w\-]+/ }) do

    resources :terminals do
      member do
        post 'send_token'
      end
    end

  end

  namespace :device do
    resources :pairings, only: [:create, :destroy], param: :token
  end

  root 'pages#index'
end
