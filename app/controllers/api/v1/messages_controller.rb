class Api::V1::MessagesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    network = Network.find_by(post_code: params[:post_code])
    if network.present?
      if params[:undercover] == 'true'
        render json: network.messages.where(undercover: true).as_json(methods: [:image_urls])
      else
        render json: network.messages.where(undercover: false).as_json(methods: [:image_urls])
      end
    else
      head 204
    end
  end

  def create
    # m_params = JSON.parse(params[:message])
    @message = Message.new(message_params)
    if @message.save
      params[:images].each do |i|
        image = Image.create(image: i)
        @message.images << image
      end
      render json: @message.as_json(methods: [:image_urls])
    else
      head 422
    end
  end

  def update
    @message = Message.find_by(id: params[:id])
    if @message
      @message.images << Image.new(image: params[:image])
      render json: @message.as_json(methods: [:image_urls])
    else
      head 422
    end
  end

  private

  def message_params
    params.require(:message).permit(:text,
                                    :user_id,
                                    :lng,
                                    :lat,
                                    :undercover,
                                    :network_id)
  end
end
