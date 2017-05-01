# Like up and down
class Api::V1::UserLikesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    @like = UserLike.new(like_params)
    if @like.save
      message = Message.find_by(id: params[:user_like][:message_id])
      message.likes_count += 1
      message.save
      render json: message
    else
      head 422
    end
  end

  private

  def like_params
    params.require(:user_like).permit(:user_id,
                                      :message_id)
  end
end
