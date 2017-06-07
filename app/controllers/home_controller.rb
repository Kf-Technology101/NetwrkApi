class HomeController < ApplicationController
  skip_before_filter :check_token

  def index
    @subscriber = Subscriber.new
  end

  def create_subscriber
    @subscriber = Subscriber.find_by(email: params[:subscriber][:email])
    if @subscriber.present?
      flash[:notice] = "User already exist..."
      redirect_to root_path
    else
      @subscriber = Subscriber.new(subscriber_params)
      if @subscriber.save
        flash[:notice] = "Successfully subscribed..."
        redirect_to root_path
      else
        flash[:notice] = "Sorry something went wrong..."
        redirect_to root_path
      end
    end
  end

  def privacy
  end

  def clear_messages
    @messages = Message.all
    @messages.each do |m|
      m.destroy
    end
    Image.all.map(&:destroy)
    redirect_to root_path
  end

  private

  def subscriber_params
    params.require(:subscriber).permit(:email, :description)
  end
end
