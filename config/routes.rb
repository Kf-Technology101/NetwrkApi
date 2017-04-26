Rails.application.routes.draw do
  root 'home#index'
  resources :home, only: [:index], path: '' do
    collection do
      get 'privacy'
    end
  end

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  namespace :api do
    namespace :v1 do
      resources :registrations, only: [:create, :update] do
        collection do
          get 'check_login'
        end
      end
      resources :providers
      resources :networks, only: [:index, :create]
      resources :messages do
        collection do
          post 'lock'
        end
      end
      resources :networks_users, only: [:index]
      resources :members, only: [:create]
      resources :profiles
      resources :sessions, only: [:create, :destroy] do
        collection do
          post 'oauth_login'
          post 'verification'
        end
      end
      resources :user_likes, only: [:create]
      resources :invitations, only: [:create]
      get '/sms', to: 'invitations#sms'
    end
  end
end
