Rails.application.routes.draw do
  # root to: 'pages#index'

  post 'stripe_webhook', to: 'webhooks#index'

  mount HealthBit.rack => '/health'

  # get '*path', to: 'pages#index', format: false, via: :get
end
