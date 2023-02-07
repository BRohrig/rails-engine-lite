class Api::V1::Merchants::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(MerchantItemsFacade.find_all_by_merch_id(params[:merchant_id]))
  end

end