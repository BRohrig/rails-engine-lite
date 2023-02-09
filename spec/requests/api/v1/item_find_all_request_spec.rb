require 'rails_helper'

RSpec.describe 'item find_all search endpoint' do
  before(:each) do
    @merchant1 = create(:merchant)
    @merchant2 = create(:merchant)
    @merchant3 = create(:merchant)
    @item = create(:item, merchant_id: @merchant1.id, unit_price: 3.5, name: 'Muffin')
    @item2 = create(:item, merchant_id: @merchant1.id, unit_price: 4.5, name: 'Bagel')
    @item3 = create(:item, merchant_id: @merchant1.id, unit_price: 5.5, name: 'bread')
    @item4 = create(:item, merchant_id: @merchant2.id, unit_price: 5.5, name: 'cheese')
    @item5 = create(:item, merchant_id: @merchant2.id, unit_price: 6.5, name: 'cheesebread')
    @item6 = create(:item, merchant_id: @merchant3.id, unit_price: 7.0, name: 'bagelmuffin')
    @item7 = create(:item, merchant_id: @merchant3.id, unit_price: 8.0, name: 'cheesebagelmuffin')
  end

  it 'returns all items that match a name fragment' do
    get '/api/v1/items/find_all?name=bag'

    item_data = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(item_data[:data][0][:attributes][:name]).to eq('Bagel')
    expect(item_data[:data][1][:attributes][:unit_price]).to eq(7.0)
    expect(item_data[:data][2][:attributes][:name]).to eq('cheesebagelmuffin')
  end

  it 'accepts minimum price parameter and returns all items over that price' do
    get '/api/v1/items/find_all?min_price=6.5'

    item_data = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(item_data[:data][0][:attributes][:name]).to eq('cheesebread')
    expect(item_data[:data][1][:attributes][:name]).to eq('bagelmuffin')
    expect(item_data[:data][2][:attributes][:name]).to eq('cheesebagelmuffin')
    expect(item_data[:data].count).to eq(3)
  end

  it 'accepts a maximum price parameter and returns all items under that price' do
    get '/api/v1/items/find_all?max_price=5.5'

    item_data = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(item_data[:data][0][:attributes][:name]).to eq('Muffin')
    expect(item_data[:data][1][:attributes][:name]).to eq('Bagel')
    expect(item_data[:data][2][:attributes][:name]).to eq('bread')
    expect(item_data[:data][3][:attributes][:name]).to eq('cheese')
    expect(item_data[:data].count).to eq(4)
  end

  it 'accepts both min and max price and returns all items between those' do
    get '/api/v1/items/find_all?min_price=5&max_price=6.9'

    item_data = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(item_data[:data][0][:attributes][:name]).to eq('bread')
    expect(item_data[:data][1][:attributes][:name]).to eq('cheese')
    expect(item_data[:data][2][:attributes][:name]).to eq('cheesebread')
    expect(item_data[:data].count).to eq(3)
  end

  it 'returns a 400 error if invalid parameters are input' do
    get '/api/v1/items/find_all?min_price=5&max_price=6.9&name=cheese'

    expect(response.status).to eq(400)
  end
end
