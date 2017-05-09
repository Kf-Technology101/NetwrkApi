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
        messages = Message.where(id: messages.map(&:id))
        ids_to_exclude = current_user.messages_deleted.pluck(:message_id)
        messages = messages.where.not(id: ids_to_exclude).order(created_at: :desc).limit(params[:limit]).offset(params[:offset])
        render json: messages.as_json(methods: [:image_urls, :like_by_user, :legendary_by_user, :user])
      else
        messages = network.messages
        if messages.present?
          messages.each do |m|
            m.current_user = current_user
          end
          messages = messages.limit(params[:limit]).order(created_at: :desc).offset(params[:offset])#.order(:created_at)
          render json: messages.where(undercover: false).as_json(methods: [:image_urls, :like_by_user, :legendary_by_user])
        else
          render json: {messages: []}
        end
      end
    else
      head 204
    end
  end

  def create
    @message = Message.new(message_params)
    puts @message.valid?
    puts @message.errors.messages
    if @message.save
      if params[:images].present?
        params[:images].each do |i|
          image = Image.create(image: i)
          @message.images << image
        end
      end
      if params[:message][:social_urls].present?
        params[:message][:social_urls].each do |i|
          image = Image.create(image: URI.parse(i))
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

  def delete
    @messages = Message.where(id: params[:ids])
    if @messages
      @messages.each do |m|
        current_user.messages_deleted << m
      end
      head 204
    else
      head 422
    end
  end

  private

  def message_params
    params.require(:message).permit(:text,
                                    :is_emoji,
                                    :user_id,
                                    :lng,
                                    :lat,
                                    :undercover,
                                    :network_id,
                                    :public,
                                    :social)
  end
end
