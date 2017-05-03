class Api::V1::ProfilesController < ApplicationController
  def show
    user = User.find_by(id: params[:id])
    if user.present?
      render json: user.as_json(methods: [:avatar_url]), except: [:auth_token, :created_at, :encrypted_password]
    else
      head 404
    end
  end

  def user_by_provider
    @provider = Provider.find_by(provider_id: params[:provider_id])
    puts @provider.inspect
    if @provider.present?
      render json: @provider.user.as_json(methods: [:avatar_url])
    else
      head 204
    end
  end
end
