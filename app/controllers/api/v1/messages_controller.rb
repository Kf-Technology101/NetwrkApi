class Api::V1::MessagesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    network = Network.find_by(post_code: params[:post_code])
    if network.present?
      messages = CheckDistance.messages_in_radius(params[:post_code],
                                                  params[:lng],
                                                  params[:lat],
                                                  current_user.id,
                                                  true)
      undercover_messages = Message.where(id: messages.map(&:id))
      ids_to_exclude = current_user.messages_deleted.pluck(:message_id)
      undercover_messages = undercover_messages.where.not(id: ids_to_exclude).order(created_at: :desc).limit(params[:limit]).offset(params[:offset]).includes(:images)
      messages = network.messages
      if messages.present?
        messages.each do |m|
          m.current_user = current_user
        end
        messages = messages.where(undercover: false).order(created_at: :desc).limit(params[:limit]).offset(params[:offset]).includes(:images)#.order(:created_at)
      end
      if params[:user_id].present?
        undercover_messages = undercover_messages.where(user_id: params[:user_id])
        messages = messages.where(user_id: params[:user_id])
      end
      if params[:undercover] == 'true'
        if params[:current_ids].present?
          quered_ids = undercover_messages.present? ? undercover_messages.pluck(:id) : []
          if params[:current_ids].split(',').map(&:to_i) == (params[:current_ids].split(',').map(&:to_i) && quered_ids)
            ids_to_remove = []
            undercover_messages = []
          else
            ids_to_remove = params[:current_ids].split(',').map(&:to_i) - quered_ids
            new_ids = quered_ids - params[:current_ids].split(',').map(&:to_i)
            undercover_messages = undercover_messages.where(id: new_ids)#Message.where(id: new_ids).order(created_at: :desc).includes(:images)
            undercover_messages.where(locked: true).each do |m|
              locked = LockedMessage.find_by(user_id: current_user.id, message_id: m.id)
              unless locked.present?
                LockedMessage.create(user_id: current_user.id, message_id: m.id)
              end
            end
            undercover_messages.each do |m|
              m.current_user = current_user
            end
            undercover_messages = undercover_messages.as_json(methods: [:image_urls, :like_by_user, :legendary_by_user, :user, :text_with_links, :post_url, :expire_at, :has_expired, :locked_by_user])
          end
        else
          ids_to_remove = []
          undercover_messages.where(locked: true).each do |m|
            locked = LockedMessage.find_by(user_id: current_user.id, message_id: m.id)
            unless locked.present?
              LockedMessage.create(user_id: current_user.id, message_id: m.id)
            end
          end
          undercover_messages.each do |m|
            m.current_user = current_user
          end
          undercover_messages = undercover_messages.as_json(methods: [:image_urls, :like_by_user, :legendary_by_user, :user, :text_with_links, :post_url, :expire_at, :has_expired, :locked_by_user])
        end
        render json: {messages: undercover_messages, ids_to_remove: ids_to_remove}
      elsif params[:undercover] == 'false'
        netwrk_ids_to_exclude = current_user.messages_deleted.pluck(:message_id)
        messages = messages.where.not(id: netwrk_ids_to_exclude)
        messages.each do |m|
          m.current_user = current_user
        end
        render json: {messages: messages.as_json(methods: [:image_urls, :like_by_user, :legendary_by_user, :user, :text_with_links, :post_url, :expire_at, :has_expired])}
      else
        message_list = undercover_messages + messages
        render json: {messages: message_list.as_json(methods: [:image_urls, :like_by_user, :legendary_by_user, :user, :text_with_links, :post_url, :expire_at, :has_expired])}
      end
    else
      messages = CheckDistance.messages_in_radius(params[:post_code],
                                                  params[:lng],
                                                  params[:lat],
                                                  current_user.id,
                                                  true)
      undercover_messages = Message.where(id: messages.map(&:id)).uniq
      ids_to_exclude = current_user.messages_deleted.pluck(:message_id)
      undercover_messages = undercover_messages.where.not(id: ids_to_exclude).order(created_at: :desc).limit(params[:limit]).offset(params[:offset]).includes(:images)
      if params[:current_ids].present?
        quered_ids = undercover_messages.pluck(:id)
        if params[:current_ids].split(',').map(&:to_i) == (params[:current_ids].split(',').map(&:to_i) && quered_ids)
          ids_to_remove = []
          undercover_messages = []
        else
          ids_to_remove = params[:current_ids].split(',').map(&:to_i) - quered_ids
          new_ids = quered_ids - params[:current_ids].split(',').map(&:to_i)
          undercover_messages = undercover_messages.where(id: new_ids)#Message.where(id: new_ids).order(created_at: :desc).includes(:images)
          undercover_messages.each do |m|
            m.current_user = current_user
          end
          undercover_messages = undercover_messages.as_json(methods: [:image_urls, :like_by_user, :legendary_by_user, :user, :text_with_links, :post_url, :expire_at, :has_expired])
        end
      else
        ids_to_remove = []
        undercover_messages.each do |m|
          m.current_user = current_user
        end
        undercover_messages = undercover_messages.as_json(methods: [:image_urls, :like_by_user, :legendary_by_user, :user, :text_with_links, :post_url, :expire_at, :has_expired])
      end
      render json: {messages: undercover_messages}
    end
  end

  def profile_messages
    network = Network.find_by(id: params[:network_id])
    if network.present?
      if params[:undercover] == 'true'
        messages = CheckDistance.messages_in_radius(network.post_code,
                                                    params[:lng],
                                                    params[:lat],
                                                    current_user.id,
                                                    true)
        if params[:public] == 'true'
          puts 'public'
          messages = Message.where(id: messages.map(&:id), user_id: params[:user_id], public: true)
          puts messages.count
        else
          puts 'public false'
          messages = Message.where(id: messages.map(&:id), user_id: params[:user_id], public: false)
          puts messages.count
        end
        ids_to_exclude = current_user.messages_deleted.pluck(:message_id)
        undercover_messages = messages.where.not(id: ids_to_exclude).order(created_at: :desc).limit(params[:limit]).offset(params[:offset]).includes(:images)
        messages = undercover_messages + Message.where(social: params[:social], user_id: current_user.id).order(created_at: :desc).limit(params[:limit]).offset(params[:offset]).includes(:images)
      else
        messages = network.messages.where(user_id: params[:user_id]).order(created_at: :desc).limit(params[:limit]).offset(params[:offset]).includes(:images)
      end
      render json: {messages: messages.as_json(methods: [:image_urls, :like_by_user, :legendary_by_user, :user, :text_with_links, :post_url, :expire_at, :has_expired])}
    elsif params[:public] == 'true'
      messages = Message.where(social: ['facebook', 'twitter'], user_id: current_user.id).order(created_at: :desc).limit(params[:limit]).offset(params[:offset]).includes(:images)
      render json: {messages: messages.as_json(methods: [:image_urls, :like_by_user, :legendary_by_user, :user, :text_with_links, :post_url, :expire_at, :has_expired])}
    else
      head 204
    end
  end

  def social_feed
    FeedFetch.user_fetch(current_user.id)
    TwitterFeed.perform(current_user.id)
    messages = Message.where(social: params[:social], user_id: current_user.id).order(created_at: :desc).limit(params[:limit]).offset(params[:offset]).includes(:images)
    render json: {messages: messages.as_json(methods: [:image_urls, :like_by_user, :legendary_by_user, :user, :text_with_links, :post_url, :expire_at, :has_expired])}
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
      if params[:message][:locked] == true
        @message.update_attributes(hint: params[:message][:hint], locked: true)
        @message.save_password(params[:message][:password])
      end
      @message.current_user = current_user
      ActionCable.server.broadcast "messages#{params[:post_code]}chat", message: @message.as_json(methods: [:image_urls, :user, :text_with_links, :expire_at, :has_expired, :locked_by_user])
      # head 204
      render json: @message.as_json(methods: [:image_urls, :user, :text_with_links, :locked_by_user])
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
    puts @message.present?
    puts @message.correct_password?(params[:password])
    if @message.present? && @message.correct_password?(params[:password])
      # @message.update_attributes(locked: false,
      #                            password_salt: nil,
      #                            password_hash: nil)
      # @message.save
      m = LockedMessage.find_by(message_id: @message.id, user_id: current_user.id)
      if m.present?
        m.unlocked = true
        m.save
      end
      render json: @message.as_json(methods: [:image_urls])
    else
      head 422
    end
  end

  def legendary_list
    network = Network.find_by(id: params[:network_id])
    if network.present?
      message_ids = network.messages.pluck(:id)
      ids = LegendaryLike.where(message_id: message_ids).pluck(:message_id).uniq
      ids_to_exclude = current_user.messages_deleted.pluck(:message_id)
      messages = Message.where(id: ids)
      messages = messages.where.not(id: ids_to_exclude)
      render json: {messages: messages.as_json(methods: [:image_urls, :like_by_user, :legendary_by_user, :user, :text_with_links, :post_url])}
    else
      head 204
    end
  end

  def sms_sharing
    params[:phone_numbers].each do |phone|
      TwilioConnect.perform(phone, params[:message])
    end
    head 204
  end

  def delete
      # message_ids = CheckDistance.messages_in_radius(params[:post_code],
      #                                                params[:lng],
      #                                                params[:lat],
      #                                                current_user.id,
      #                                                true)
      # messages = Message.where(id: message_ids.map(&:id)).uniq
      # puts current_user.inspect
      # puts messages.inspect
      # ids_to_exclude = current_user.messages_deleted.pluck(:message_id)
      # puts ids_to_exclude
      # messages_to_delete = messages.where.not(id: ids_to_exclude)
      # puts messages_to_delete.inspect
      # if messages_to_delete.present?
      #   messages_to_delete.each do |m|
      #     current_user.messages_deleted << m
      #   end
      #   head 204
      # else
      #   head 422
      # end
    @messages = Message.where(id: params[:ids])
    if @messages
      @messages.each do |m|
        current_user.messages_deleted << m
      end
      head 204
    else
      head 422
    end
    # @messages = Message.where(network_id: params[:network_id])
    # @messages = @messages.where.not(id: ids_to_exclude)
    # if @messages
    #   @messages.each do |m|
    #     current_user.messages_deleted << m
    #   end
    #   head 204
    # else
    #   head 422
    # end
  end

  def block
    message = Message.find_by(id: params[:message_id])
    if message.present?
      current_user.messages_deleted << message
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
                                    :social,
                                    :hint,
                                    :expire_date)
  end
end
