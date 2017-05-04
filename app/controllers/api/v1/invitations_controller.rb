class Api::V1::InvitationsController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_filter :check_token

  def create
    # contact_list = JSON.dump(params[:contact_list])
    # contact_list = params[:contact_list]
    # params = params.to_h
    contact_list = invite_params.to_h
    # params_to_send = []
    # contact_list.each do |contact|
    #   puts contact.inspect
    #   params_to_send << contact
    # end
    # puts params_to_send
    EmailWorker.perform_async(contact_list)
    render json: {status: 'success'}, status: 200
  rescue
    render json: {status: 'Something went wrong'}, status: 422
  end

  def sms
    TwilioConnect.perform('+380963855593', '1234')
    render json: {success: 'ok'}, status: 200
  end

  private

  def invite_params
    params.require(:invitation).permit(contact_list: [:name, :email, :phone])
  end
end
