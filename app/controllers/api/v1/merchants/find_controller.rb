class Api::V1::Merchants::FindController < ApplicationController
  def search
    if !params[:name] || params[:name] == ''
      render json: { error: 'Please Input Valid Parameter' }, status: 400
    elsif Merchant.find_by_name_fragment(params[:name]) == []
      render json: { data: {} }, status: :ok
    elsif Merchant.find_by_name_fragment(params[:name])
      render json: MerchantSerializer.new(Merchant.find_by_name_fragment(params[:name]).first)
    end
  end
end
