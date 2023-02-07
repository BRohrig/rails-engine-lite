require 'rails_helper'

RSpec.describe "merchant find API endpoint" do
  it 'returns a single merchant if one matches' do
    merchant = create(:merchant, name: "Happy Muffin World")

    get "/api/v1/merchants/find?name=app"

    merchant_data = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(merchant_data[:data][:attributes]).to have_key(:name)
    expect(merchant_data[:data][:attributes][:name]).to be_a(String)
    expect(merchant_data[:data][:attributes][:name]).to eq("Happy Muffin World")
  end

  


end