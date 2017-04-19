# Login Api Part
class Api::V1::SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_filter :check_token, except: [:invitation_check]

  def create
    user_password = params[:user][:password]
    user_login = params[:user][:login].downcase!
    user = user_login.present? && User.where('email = ? OR phone = ?', user_login, user_login).first
    if user && user.valid_password?(user_password)
      sign_in user, store: false
      user.generate_authentication_token!
      user.save
      render json: user, status: 200
    else
      render json: { errors: 'Invalid login or password' }, status: 422
    end
  end

  def oauth_login
    user_id = params[:user][:provider_id]
    user_provider = params[:user][:provider_name]
    provider = user_id.present? && Provider.find_by(provider_id: user_id)
    if provider
      user = provider.user
      sign_in user, store: false
      user.generate_authentication_token!
      user.save
    else
      user = User.create!(oauth_params)
      user.providers << Provider.create(name: user_provider,
                                        token: params[:user][:token],
                                        provider_id: params[:user][:provider_id])
    end
    render json: user, status: 200
  end

  def verification
    message = ChooseType.start(params[:login], params[:country_code])
    render json: message
  end

  def destroy
    user = User.find_by(auth_token: params[:id])
    user.generate_authentication_token!
    user.save
    head 204
  end

  private

  def oauth_params
    params.require(:user).permit(:first_name,
                                 :last_name,
                                 :email,
                                 :password,
                                 :phone,
                                 :provider_id,
                                 :provider_name)
  end
end
