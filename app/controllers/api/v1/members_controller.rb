class Api::V1::MembersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    network = Network.find_by(post_code: params[:post_code])
    if network.present? 
      network.users << current_user
      network.update_attributes( users_count: network.users_count +=1 )
      network.save
      render json: network
    else
      head 422
    end
  end
end
