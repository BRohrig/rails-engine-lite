require 'rails_helper'

RSpec.describe "items API" do
  before(:each) do
    @merchant = create(:merchant)
  end

  it "sends a list of items" do
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

  it "can find a single item by its ID" do
    id = create(:item, merchant_id: @merchant.id).id

    get "/api/v1/items/#{id}"

    item_data = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(item_data[:data]).to have_key(:id)
    expect(item_data[:data][:id]).to eq(id.to_s)
    expect(item_data[:data][:attributes]).to have_key(:name)
    expect(item_data[:data][:attributes][:name]).to be_a(String)
    expect(item_data[:data][:attributes]).to have_key(:description)
    expect(item_data[:data][:attributes][:description]).to be_a(String)
    expect(item_data[:data][:attributes]).to have_key(:unit_price)
    expect(item_data[:data][:attributes][:unit_price]).to be_a(Float)
    expect(item_data[:data][:attributes]).to have_key(:merchant_id)
    expect(item_data[:data][:attributes][:merchant_id]).to eq(@merchant.id)
  end

  it 'can create a new item' do
    item_params = ({
                    name: "Shiny Thing", 
                    description: "Crows Love this Item",
                    unit_price: 3.2,
                    merchant_id: @merchant.id
                  })
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
    created_item = Item.last

    expect(response).to be_successful
    expect(created_item.name).to eq("Shiny Thing")
    expect(created_item.description).to eq("Crows Love this Item")
    expect(created_item.unit_price).to eq(3.2)
    expect(created_item.merchant_id).to eq(@merchant.id)
  end

  it 'can edit an existing item' do
    id = create(:item, merchant_id: @merchant.id).id
    @merchant2 = create(:merchant)
    change_params = {
                      name: "Dull Thing", 
                      description: "this is much more boring", 
                      unit_price: 0.1,
                      merchant_id: @merchant2.id
                    }
    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate(item: change_params)
    item = Item.find_by(id: id)

    expect(response).to be_successful
    expect(item.name).to_not eq("Shiny Thing")
    expect(item.name).to eq("Dull Thing")
    expect(item.description).to_not eq("Crows Love this Item")
    expect(item.description).to eq("this is much more boring")
    expect(item.unit_price).to_not eq(3.2)
    expect(item.unit_price).to eq(0.1)
    expect(item.merchant_id).to_not eq(@merchant.id)
    expect(item.merchant_id).to eq(@merchant2.id)
  end

  it 'can destroy an item in the database' do
    item = create(:item, merchant_id: @merchant.id)

    expect(Item.count).to eq(1)

    delete "/api/v1/items/#{item.id}"

    expect(response.body).to eq("")
    expect(response.code).to eq("204")
    expect(Item.count).to eq(0)
    expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'can delete an invoice if it is the only item on that invoice' do
    item = create(:item, merchant_id: @merchant.id)
    customer = create(:customer)
    invoice = create(:invoice, customer_id: customer.id)
    ii = create(:invoice_item, invoice_id: invoice.id, item_id: item.id)

    delete "/api/v1/items/#{item.id}"

    expect(response).to be_successful
    expect{Invoice.find(invoice.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'will not delete the invoice if other items exist on that invoice' do
    item = create(:item, merchant_id: @merchant.id)
    item2 = create(:item, merchant_id: @merchant.id)
    customer = create(:customer)
    invoice = create(:invoice, customer_id: customer.id)
    ii = create(:invoice_item, invoice_id: invoice.id, item_id: item.id)
    ii2 = create(:invoice_item, invoice_id: invoice.id, item_id: item2.id)

    delete "/api/v1/items/#{item.id}"

    expect(response).to be_successful
    expect{Invoice.find(invoice.id)}.to eq(invoice)
  end
end