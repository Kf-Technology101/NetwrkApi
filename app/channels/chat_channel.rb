class ChatChannel < ApplicationCable::Channel
  def subscribed#(zip_code)
    stream_from 'chat_channel'#+zip_code
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
