require 'rails_helper'

RSpec.describe 'merchants API' do
  it 'sends a list of merchants' do
    create_list(:merchant, 10)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants_data = JSON.parse(response.body, symbolize_names: true)
    expect(merchants_data[:data].count).to eq(10)

    merchants_data[:data].each do |merchant|
      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end

  it 'can find a single merchant by its ID' do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    merchant_data = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(merchant_data[:data][:attributes]).to have_key(:name)
    expect(merchant_data[:data][:attributes][:name]).to be_a(String)
    expect(merchant_data[:data][:id]).to eq(id.to_s)
  end
end
