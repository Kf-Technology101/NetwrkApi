class Api::V1::ProvidersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    current_user.providers << Provider.new(provider_params)
    # if provider.save
    render json: {status: 'ok'}, status: 200
    # else
    #   render json: {status: 'Unpossible Entity'}, status: 422
    # end
  end

  private
  def provider_params
    params.require(:provider).permit(:name,
                                     :token,
                                     :secret)
  end
end
