class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include Authenticable

  before_action :check_token, except: :devise_controller

  def check_token
    api_key = request.headers['Authorization']
    @user = User.where(auth_token: api_key).first if api_key

    unless @user
      head status: :unauthorized
      return false
    end
  end

  def facebook_oauth
    
  end
end
