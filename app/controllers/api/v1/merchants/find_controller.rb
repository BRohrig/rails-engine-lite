class Api::V1::Merchants::FindController < ApplicationController
  def search
    if Merchant.find_by_name_fragment(params[:name])
      render json: MerchantSerializer.new(Merchant.find_by_name_fragment(params[:name]))
    else
      render json: { data: {} }, status: :ok
    end
  end
end
