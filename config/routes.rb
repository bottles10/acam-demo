Rails.application.routes.draw do
  constraints(SubdomainConstraint) do
    scope module: 'schools' do
      root 'dashboard#index', as: :school_root
      get 'waiting_room', to: 'dashboard#waiting_room', as: :waiting_room
      get 'teachers', to: 'dashboard#teachers', as: :teachers
      patch 'teachers/:id/update_role', to: 'dashboard#update_role', as: :update_role
    end
    devise_for :users
    resources :students do
      resources :reports
    end
    resources :semesters, except: %i[ edit update ] do
      resources :assessments, only: %i[ new create destroy ], module: :semesters
      resources :billings, module: :semesters
    end
    resources :subjects
    resources :cutoffs
    resources :schools, only: %i[ edit update ]
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  resources :schools, only: [:new, :create]
  root 'schools#new', as: :main_root
end
