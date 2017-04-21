# Like up and down
class Api::V1::UserLikesController < ApplicationController
  def create
    @like = UserLike.new(like_params)
    if @like.save
      message = Message.find_by(id: params[:like][:message_id])
      message.increment(:likes_count)
      head 200
    else
      head 422
    end
  end

  private

  def like_params
    params.require(:like).require(:user_id,
                                  :message_id)
  end
end
