class Api::V1::MessagesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    network = Network.find_by(post_code: params[:post_code])
    if network.present?
      render json: network.messages
    else
      head 404
    end
  end

  def create
    @message = Message.new(message_params)
    if @message.save
      params[:message][:images].each do |image|
        @message.images << Image.new(image: image)
      end
      render json: @message
    else
      head 422
    end
  end

  private

  def message_params
    params.require(:message).permit(:image,
                                    :text,
                                    :user_id,
                                    :lng,
                                    :lat,
                                    :undercover,
                                    :network_id)
  end
end
