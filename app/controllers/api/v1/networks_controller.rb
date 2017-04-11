class Api::V1::NetworksController < ApplicationController
  def index
    post_code = params[:post_code]
    @network = Network.find_by(post_code: post_code)
    if @network
      render json: @network, status: 200
    else
      render json: {message: 'Network not found'}, status: 200
    end
  end

  def create
    @network = Network.new(post_code: params[:post_code])
    if @network.save
      render json: @network
    else
      head 422
    end
  end
end
