require 'rails_helper'

RSpec.describe "item find_all search endpoint" do
  before(:each) do
    @merchant1 = create(:merchant)
    @merchant2 = create(:merchant)
    @merchant3 = create(:merchant)
    @item = create(:item, merchant_id: @merchant1.id, unit_price: 3.5, name: "Muffin")
    @item2 = create(:item, merchant_id: @merchant1.id, unit_price: 4.5, name: "Bagel")
    @item3 = create(:item, merchant_id: @merchant1.id, unit_price: 5.5, name: "bread")
    @item4 = create(:item, merchant_id: @merchant2.id, unit_price: 5.5, name: "cheese")
    @item5 = create(:item, merchant_id: @merchant2.id, unit_price: 6.5, name: "cheesebread")
    @item6 = create(:item, merchant_id: @merchant3.id, unit_price: 7.0, name: "bagelmuffin")
    @item7 = create(:item, merchant_id: @merchant3.id, unit_price: 8.0, name: "cheesebagelmuffin")
  end

  it 'returns all items that match a name fragment' do
    get "/api/v1/items/find?name=bag"

    item_data = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(item_data[:data][0][:name]).to eq("Bagel")
    expect(item_data[:data][1][:unit_price]).to eq(7.0)

  end



end