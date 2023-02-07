class Api::V1::Merchants::ItemsController < ApplicationController
  def index
    render json: Item.find_by_merch_id(params[:merchant_id])
  end

end