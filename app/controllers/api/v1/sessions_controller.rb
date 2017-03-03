# Login Api Part
class Api::V1::SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_filter :check_token

  def create
    user_password = params[:user][:password]
    user_phone = params[:user][:phone]
    user = user_phone.present? && User.find_by(phone: user_phone)
    if user && user.valid_password?(user_password)
      sign_in user, store: false
      user.generate_authentication_token!
      user.save
      render json: user, status: 200
    else
      render json: { errors: 'Invalid phone or password' }, status: 422
    end
  end

  def oauth_login
    user_id = params[:user][:provider_id]
    user_provider = params[:user][:provider_name]
    user = user_id.present? && User.find_by(provider_id: user_id)
    if user
      sign_in user, store: false
      user.generate_authentication_token!
      user.save
    else
      user = User.create!(oauth_params)
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
