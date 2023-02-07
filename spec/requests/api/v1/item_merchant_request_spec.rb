require 'rails_helper'

RSpec.describe "item's merchant API endpoint" do
  it 'finds the associated merchant information' do
    @merchant = create(:merchant)
    @merchant2 = create(:merchant)
    @merchant3 = create(:merchant)
    @item = create(:item, merchant_id: @merchant.id)

    get "/api/v1/items/#{@item.id}/merchant"

    expect(response).to be_successful

    merchant_data = JSON.parse(response.body, symbolize_names: true)

    expect(merchant_data[:data][:attributes]).to have_key(:name)
    expect(merchant_data[:data][:attributes][:name]).to eq(@merchant.name)
    expect(merchant_data[:data][:attributes][:name]).to_not eq(@merchant2.name)
    expect(merchant_data[:data][:attributes][:name]).to_not eq(@merchant3.name)
  end
end