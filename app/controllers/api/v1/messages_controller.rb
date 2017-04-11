class Api::V1::MessagesController < ApplicationController
  def create
    @message = Message.new(message_params)
    if @message.save
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
                                    :undercover)
  end
end
