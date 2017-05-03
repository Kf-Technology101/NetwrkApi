class Api::V1::LegendaryLikesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    @like = LegendaryLike.where(message_id: params[:legendary][:message_id],
                                user_id: current_user.id).first
    message = Message.find_by(id: params[:legendary][:message_id])
    if @like.present?
      @like.destroy
      message.legendary_count -= 1
      message.save
      render json: message
    else
      @like = LegendaryLike.new(like_params)
      if @like.save
        message.legendary_count += 1
        message.save
        render json: message
      else
        head 422
      end
    end
  end

  private

  def like_params
    params.require(:legendary).permit(:user_id,
                                      :message_id)
  end
end
