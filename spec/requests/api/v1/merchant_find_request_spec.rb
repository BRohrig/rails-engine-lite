require 'rails_helper'

RSpec.describe 'merchant find API endpoint' do
  before(:each) do
    @merchant = create(:merchant, name: 'Happy Muffin World')
  end

  it 'returns a single merchant if one matches' do
    get '/api/v1/merchants/find?name=app'

    merchant_data = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(merchant_data[:data][:attributes]).to have_key(:name)
    expect(merchant_data[:data][:attributes][:name]).to be_a(String)
    expect(merchant_data[:data][:attributes][:name]).to eq('Happy Muffin World')
  end

  it 'returns a single merchant, case insensitive' do
    get '/api/v1/merchants/find?name=hap'

    merchant_data = JSON.parse(response.body, symbolize_names: true)
    expect(merchant_data[:data][:attributes][:name]).to eq('Happy Muffin World')
  end

  it 'returns a single merchant with spaces' do
    get '/api/v1/merchants/find?name=y%20m'

    merchant_data = JSON.parse(response.body, symbolize_names: true)
    expect(merchant_data[:data][:attributes][:name]).to eq('Happy Muffin World')
  end

  it 'returns a not found error when no match is present' do
    get '/api/v1/merchants/find?name=aasdfasd'

    data = JSON.parse(response.body, symbolize_names: true)
    expect(response).to be_successful
    expect(data).to have_key(:data)
    expect(data[:data]).to eq({})
  end

  it 'returns a 404 error when no name param is passed' do
    get '/api/v1/merchants/find?name='

    expect(response.status).to eq(400)
    error_return = JSON.parse(response.body, symbolize_names: true)
    expect(error_return).to have_key(:error)

  end
end
