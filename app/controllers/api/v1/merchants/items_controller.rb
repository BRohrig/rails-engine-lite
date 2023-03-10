module Api
  module V1
    module Merchants
      class ItemsController < ApplicationController
        def index
          render json: ItemSerializer.new(MerchantItemsFacade.find_all_by_merch_id(params[:merchant_id]))
        end
      end
    end
  end
end
