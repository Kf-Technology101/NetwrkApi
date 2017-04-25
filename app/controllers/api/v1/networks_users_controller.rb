class Api::V1::NetworksUsersController < ApplicationController
  def index
    @network = Network.find_by(post_code: params[:post_code])
    if @network
      render json: @network.users.as_json(methods: [:avatar_url])
    else
      head 204
    end
  end
end
