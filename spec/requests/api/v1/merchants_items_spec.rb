require 'rails_helper'

RSpec.describe "merchant items API" do
  it "can find all items associated with a merchant" do
    create_list(:merchant, 3)
    5.times do
      create(:item, merchant_id: Merchant.first.id)
    end

    3.times do
      create(:item, merchant_id: Merchant.second.id)
    end

    get "/api/v1/merchants/#{Merchant.first.id}/items"

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)
    expect(items[:data].count).to eq(5)

    items[:data].each do |item|
      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)

      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to eq(Merchant.first.id)
    end

  end


end