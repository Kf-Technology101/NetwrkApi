class Api::V1::InvitationsController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_filter :check_token

  def create
    contact_list = params[:contact_list]
    contact_list.each do |contact|
      if contact[:email].present?
        UserMailer.invitation_mail(contact[:name], contact[:email]).deliver_now
      else
        TwilioConnect.perform(contact[:phone], 'hello world')
      end
    end
    render json: {status: 'success'}, status: 200
  rescue
    render json: {status: "Something went wrong"}, status: 422
  end

  def sms
    TwilioConnect.perform('+380963855593', '1234')
    render json: {success: 'ok'}, status: 200
  end
end
