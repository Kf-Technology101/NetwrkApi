class Api::V1::ContactsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    params[:contact_list].each do |contact|
      Contact.find_or_create_by(email: contact.downcase)
    end
    head 204
  end
end
