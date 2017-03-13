Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  namespace :api do
    namespace :v1 do
      resources :registrations, only: [:create, :update]
      resources :sessions, only: [:create, :destroy] do
        collection do
          post 'oauth_login'
          post 'verification'
        end
      end
      resources :invitations, only: [:create]
      get '/sms', to: "invitations#sms"
    end
  end
end
