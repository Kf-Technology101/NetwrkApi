class Api::V1::NetworksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    post_code = params[:post_code]
    FeedFetch.user_fetch(current_user.id)
    TwitterFeed.perform(current_user.id)
    @network = Network.find_by(post_code: post_code)
    if @network
      @network.current_user = current_user
      render json: {network: @network.as_json(methods: [:accessed]), users: @network.users}, status: 200
    else
      render json: {message: 'Network not found'}, status: 200
    end
  end

  def create
    @network = Network.new(post_code: params[:post_code], users_count: 1)
    if @network.save
      @network.users << current_user
      render json: {network: @network, users: @network.users}, status: 200
    else
      head 422
    end
  end
end
