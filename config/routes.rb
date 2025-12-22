Rails.application.routes.draw do
  get "chat_messages/create"
  get "channels/index"
  get "channels/show"
  get "channels/create"
  get "channels/join"
  get "channels/leave"
  # Landing page for non-authenticated users
  get "landing" => "landing#index", as: :landing

  get "team" => "team#index", as: :team_index
  post "team/invite" => "team#invite", as: :team_invite
  resource :session
  resources :passwords, param: :token
  resources :registrations, only: [ :new, :create ]
  resources :notifications, only: [ :index ]
  resource :session
  resources :passwords, param: :token
  resources :registrations, only: [ :new, :create ]
  resources :notifications, only: [ :index ]
  get "settings" => "settings#index", as: :settings
  patch "settings" => "settings#update"

  resources :workspace_notes, only: [ :create, :destroy ]

  resources :workspace_announcements, only: [ :index, :create ] do
    member do
      post :mark_as_read
      post :toggle_pin
    end
  end

  resources :channels, only: [ :index, :show, :create ] do
    resources :chat_messages, only: [ :create ], path: "messages"
  end

  resources :automations do
    member do
      patch :toggle
    end
  end

  resources :meetings, only: [ :index, :new, :create, :show ] do
    member do
      post :dispatch_meeting
      get :meet
      get :simulator
    end
    resources :missions, only: [ :create, :destroy ]
  end

  resources :missions, only: [ :show, :edit, :update ] do
    member do
      patch :mark_in_progress
    end
    resources :mission_comments, only: [ :create ], path: "comments"
  end

  resources :integrations, only: [ :new ] do
    collection do
      get :slack_callback
    end
  end

  resources :subscriptions, only: [ :index, :create ] do
    collection do
      get :success
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "landing#index"
end
