require 'rails_helper'

RSpec.describe "merchants API" do
  it "sends a list of merchants" do
    create_list(:merchant, 10)

    get "/api/v1/merchants"

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)
    expect(merchants.count).to eq(10)

    merchants.each do |merchant|
      expect(merchant).to have_key(:name)
      expect(merchant[:name]).to be_a(String)
    end
  end

  it "can find a single merchant by its ID" do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(merchant).to have_key(:name)
    expect(merchant[:name]).to be_a(String)
    expect(merchant[:id]).to eq(id)


  end


end