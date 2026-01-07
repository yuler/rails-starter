Rails.application.routes.draw do
  root "landings#show"

  get "home", to: "home#show", as: :home

  resource :session do
    scope module: :sessions do
      # resources :transfers
      resource :magic_link
      resources :accounts
    end
  end

  namespace :account do
    resources :users
    resources :invitations
    # TODO: joinable
  end

  resources :account_invitations, param: :token, only: [ :show ] do
    scope module: :account_invitations do
      # resource :accept, only: [ :show, :update ], controller: :acceptances
    end
  end

  # Dashboard Engines
  mount MissionControl::Jobs::Engine, at: "/jobs"
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  namespace :api do
    namespace :v1, defaults: { format: :json } do
      resources :users, only: [ :index, :show, :create ]
      resources :tokens, only: [ :create ]
    end
  end
end
