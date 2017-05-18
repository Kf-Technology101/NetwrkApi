class HomeController < ApplicationController
  skip_before_filter :check_token

  def index
  end

  def privacy
  end

  def clear_messages
    @messages = Message.all
    @messages.each do |m|
      m.destroy
    end
    redirect_to root_path
  end
end
