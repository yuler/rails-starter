Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resource :registration, only: %i[new create]
  resource :session, only: %i[new create destroy]
  resource :confirmation, only: %i[show create]
  resource :password_reset, only: %i[new create edit update]

  # OAuth2 callback route
  get "auth/:provider/callback", to: "callbacks#show"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "welcome#index"

  # Define test route for only development, test env
  get "test" => "test#index"
end
