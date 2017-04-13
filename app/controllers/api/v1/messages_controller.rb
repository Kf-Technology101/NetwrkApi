class Api::V1::MessagesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    @message = Message.new(message_params)
    if @message.save
      render json: @message
    else
      head 422
    end
  end

  def index
    network = Network.find_by(id: params[:network_id])
    if network.present?
      render json: network.messages
    else
      head 404
    end
  end

  private

  def message_params
    params.require(:message).permit(:image,
                                    :text,
                                    :user_id,
                                    :lng,
                                    :lat,
                                    :undercover)
  end
end
