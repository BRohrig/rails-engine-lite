class Api::V1::Merchants::FindController < ApplicationController
  def search
binding.pry
    render json: MerchantSerializer.new(Merchant.find_by_name_fragment(params[:name]))
  end


end