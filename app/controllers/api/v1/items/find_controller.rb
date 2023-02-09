module Api
  module V1
    module Items
      class FindController < ApplicationController
        def find_all
          result = Item.search(name: params[:name], min_price: params[:min_price], max_price: params[:max_price])
          if result
            render json: ItemSerializer.new(result)
          else
            render json: { errors: 'Please Input Valid Parameter' }, status: 400
          end
        end
      end
    end
  end
end
