class Api::V1::NetworksUsersController < ApplicationController
  def index
    @network = Network.find_by(post_code: params[:post_code])
    if @network
      render json: @network.users
    else
      head 421
    end
  end
end
