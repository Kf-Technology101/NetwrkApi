class Api::V1::ProfilesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def show
    user = User.find_by(id: params[:id])
    if user.present?
      render json: user.as_json(methods: [:avatar_url, :hero_avatar_url]), except: [:auth_token, :created_at, :encrypted_password]
    else
      head 404
    end
  end

  def user_by_provider
    @provider = Provider.find_by(provider_id: params[:provider_id])
    puts @provider.inspect
    if @provider.present?
      render json: @provider.user.as_json(methods: [:avatar_url, :hero_avatar_url])
    else
      head 204
    end
  end

  def connect_social
    providers = current_user.providers
    provider = providers.where(name: params[:user][:provider_name]).first
    if provider.present?
      provider.update(token: params[:user][:token],
                      provider_id: params[:user][:provider_id],
                      secret: params[:user][:secret])
      provider.save
    else
      current_user.providers << Provider.create(name: params[:user][:provider_name],
                                                token: params[:user][:token],
                                                provider_id: params[:user][:provider_id],
                                                secret: params[:user][:secret])
    end
    head 204
  end

  def change_points_count
    user = User.find_by(id: params[:user_id])
    user.points_count += params[:points].to_i
    user.save
    render json: user
  end

  def disabled_hero
    render json: {disabled: current_user.disabled_hero?}
  end
end
