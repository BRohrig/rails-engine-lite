class Api::V1::Merchants::ItemsController < ApplicationController
  def index
    @items = MerchantItemsFacade.find_all_by_merch_id(params[:merchant_id])
    if @items.class == Error
      render json: ErrorSerializer.new(@items).serialized_error
    else
      render json: ItemSerializer.new(@items)
    end
  end

end