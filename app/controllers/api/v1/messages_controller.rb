class Api::V1::MessagesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    network = Network.find_by(post_code: params[:post_code])
    if network.present?
      if params[:undercover] == 'true'
        messages = CheckDistance.messages_in_radius(params[:post_code],
                                                    params[:lng],
                                                    params[:lat],
                                                    current_user.id,
                                                    true)
        render json: messages.as_json(methods: [:image_urls])
        # network.messages.where(undercover: true)
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
      if params[:images].present?
        params[:images].each do |i|
          image = Image.create(image: i)
          @message.images << image
        end
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

  def lock
    @message = Message.find_by(id: params[:id])
    if @message
      @message.update_attributes(hint: params[:hint], locked: true)
      @message.save_password(params[:password])
      render json: @message.as_json(methods: [:image_urls])
    else
      head 422
    end
  end

  def unlock
    @message = Message.find_by(id: params[:id])
    if @message && @message.correct_password(params[:password])
      @message.update_attributes(locked: false,
                                 password_salt: nil,
                                 password_hash: nil)
      @message.save
      render json: @message.as_json(methods: [:image_urls])
    else
      head 422
    end
  end

  def destroy
    @message = Message.find_by(id: params[:id])
    if @message
      current_user.messages << @message
      head 200
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
