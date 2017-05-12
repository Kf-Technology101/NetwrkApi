# Registration methods for API
class Api::V1::RegistrationsController < ApplicationController
  skip_before_action :verify_authenticity_token, :check_token

  def create
    resource = User.new(user_params)
    if resource.valid?
      # resource.sign_in_count = 1
      resource.save
      render json: resource.as_json(methods: [:log_in_count]), status: 200
    else
      render json: resource.errors.messages, status: 422
    end
  end

  def update
    resource = User.find_by(id: params[:id])
    resource.update(user_params)
    # resource.avatar = params[:avatar]
    if resource.valid?
      resource.save
      render json: resource.as_json(methods: [:avatar_url, :hero_avatar_url, :log_in_count]), status: 200
    else
      render json: resource.errors.messages, status: 422
    end
  end

  def check_login
    logins = User.all.pluck(params[:type].to_sym)
    if logins.include?(params[:login])
      head 422
    else
      head 204
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name,
                                 :last_name,
                                 :name,
                                 :email,
                                 :password,
                                 :phone,
                                 :date_of_birthday,
                                 :invitation_sent,
                                 :avatar,
                                 :role_name,
                                 :role_description,
                                 :role_image_url,
                                 :hero_avatar,
                                 :gender)
  end
end
