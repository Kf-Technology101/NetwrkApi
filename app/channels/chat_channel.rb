class ChatChannel < ApplicationCable::Channel
  def subscribed#(zip_code)
    puts 'I'*1000
    puts params.inspect
    # puts params.url
    # puts request.url
    stop_all_streams
    stream_from "messages#{params[:post_code]}chat"##+zip_code
  end

  def speak(data)
    ActionCable.server.broadcast "chat_channel", message: data#['message']
  end

  def unfollow
    stop_all_streams
  end

  private

  def render_message(message)
    ApplicationController.render(partial: 'messages/message',
                                 locals: { message: message })
  end
end
