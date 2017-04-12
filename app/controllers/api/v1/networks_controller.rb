class Api::V1::NetworksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    post_code = params[:post_code]
    @network = Network.find_by(post_code: post_code)
    if @network
      render json: {network: @network, users: @network.users}, status: 200
    else
      render json: {message: 'Network not found'}, status: 200
    end
  end

  def create
    @network = Network.new(post_code: params[:post_code], users_count: 1)
    if @network.save
      render json: {network: @network, users: @network.users}, status: 200
    else
      head 422
    end
  end
end
