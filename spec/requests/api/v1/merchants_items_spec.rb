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
    expect(items.count).to eq(5)

    items.each do |item|
      expect(item).to have_key(:name)
      expect(item[:name]).to be_a(String)

      expect(item).to have_key(:description)
      expect(item[:description]).to be_a(String)

      expect(item).to have_key(:unit_price)
      expect(item[:unit_price]).to be_a(Float)

      expect(item).to have_key(:merchant_id)
      expect(item[:merchant_id]).to eq(Merchant.first.id)
    end

  end


end