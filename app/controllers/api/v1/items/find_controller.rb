# frozen_string_literal: true

module Api
  module V1
    module Items
      class FindController < ApplicationController
        def find_all
          if params[:name] != '' && !params[:name].nil? && !params[:min_price] && !params[:max_price]
            render json: ItemSerializer.new(Item.find_by_name_fragment(params[:name]))
          elsif params[:min_price].to_f.positive? && params[:max_price].to_f.positive? && !params[:name]
            render json: ItemSerializer.new(Item.find_by_price(min_price: params[:min_price],
                                                               max_price: params[:max_price]))
          elsif params[:min_price].to_f.positive? && !params[:name]
            render json: ItemSerializer.new(Item.find_by_price(min_price: params[:min_price]))
          elsif params[:max_price].to_f.positive? && !params[:name]
            render json: ItemSerializer.new(Item.find_by_price(max_price: params[:max_price]))
          else
            render json: { errors: 'Please Input Valid Parameter' }, status: 400
          end
        end
      end
    end
  end
end
