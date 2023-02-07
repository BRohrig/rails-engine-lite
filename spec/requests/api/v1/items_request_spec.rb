require 'rails_helper'

RSpec.describe "items API" do
  it "sends a list of items" do
    @merchant = create(:merchant)
    create_list(:item, 10, merchant_id: @merchant.id)

    get "/api/v1/items"

    expect(response).to be_successful

    items_data = JSON.parse(response.body, symbolize_names: true)
    expect(items_data[:data].count).to eq(10)

    items_data[:data].each do |item|
      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)
      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)
      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)
      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_a(Integer)
    end
  end
end