Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  namespace :api do
    namespace :v1 do
      resources :registrations, only: [:create, :update]
      resources :providers
      resources :networks, only: [:index, :create]
      resources :messages
      resources :networks_users, only: [:index]
      resources :members, only: [:create]
      resources :profiles
      resources :sessions, only: [:create, :destroy] do
        collection do
          post 'oauth_login'
          post 'verification'
        end
      end
      resources :invitations, only: [:create]
      get '/sms', to: 'invitations#sms'
    end
  end
end
