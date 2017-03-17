class Api::V1::ProvidersController < ApplicationController
  def create
    @provider = Provider.new(provider_params)
    if @provider.save
      current_user.providers < @provider
      render json: {status: 'ok'}, status: 200
    else
      render json: {status: 'Unpossible Entity'}, status: 422
    end
  end

  private
  def provider_params
    params.require(:provider).permit(:name,
                                     :token,
                                     :secret)
  end
end
