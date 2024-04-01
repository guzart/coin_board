Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  devise_for :users

  resources :users, only: %i[show]
  resources :currencies, only: %i[index create destroy]
  resources :mailbox, only: %i[show]
  resources :senders, only: %i[index show] do
    member do
      post :approve
      post :block
    end
  end

  resources :message_dispatchers, only: %i[index show create destroy]

  resources :message_conditions, only: %i[create destroy]

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", :as => :rails_health_check

  # Defines the root path route ("/")
  root "home#index"
end
