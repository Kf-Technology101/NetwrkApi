class Api::V1::NetworksUsersController < ApplicationController
  def index
    @network = Network.find_by(post_code: params[:post_code])
    render json: @network.users
  end
end
