class Api::V1::MembersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    network = Network.find_by(post_code: params[:post_code])
    if network.present?
      NetworksUser.create(user_id: current_user.id,
                          network_id: network.id,
                          invitation_sent: true)
      UserMailer.connect_mail(current_user.id).deliver_now
      network.update_attributes(users_count: network.users_count += 1)
      network.save
      if network.users_count == 10
        GreetingsWorker.perform_async(network.id)
      end
      render json: network
    else
      head 422
    end
  end
end
