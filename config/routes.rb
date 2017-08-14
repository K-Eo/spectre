Rails.application.routes.draw do
  resources :terminals
  root 'pages#index'
end
