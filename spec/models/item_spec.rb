# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Item, type: :model do
  it { should belong_to(:merchant) }
  it { should have_many(:invoice_items) }
  it { should have_many(:invoices).through(:invoice_items) }
  it { should have_many(:customers).through(:invoices) }

  it 'has a method to delete the associated invoice if that invoice only has that item on it' do
    @merchant = create(:merchant)
    @item = create(:item, merchant_id: @merchant.id)
    @item2 = create(:item, merchant_id: @merchant.id)
    @customer = create(:customer)
    @invoice = create(:invoice, customer_id: @customer.id)
    @ii = create(:invoice_item, invoice_id: @invoice.id, item_id: @item.id)

    expect(Invoice.find(@invoice.id)).to eq(@invoice)
    @item.invoice_delete
    expect { Invoice.find(@invoice.id) }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'has a class method to search instances of itself my a name fragment, case insensitive, alphabetically' do
    @merchant = create(:merchant)
    @item = create(:item, merchant_id: @merchant.id, name: 'fuzzy wuzzy')
    @item2 = create(:item, merchant_id: @merchant.id, name: 'wuzfuzz')
    @item3 = create(:item, merchant_id: @merchant.id, name: 'fuzzzzzz')

    expect(Item.find_by_name_fragment('fuzz')).to eq([@item, @item3, @item2])
    expect(Item.find_by_name_fragment('FuzZ')).to eq([@item, @item3, @item2])
    expect(Item.find_by_name_fragment('zZy')).to eq([@item])
    expect(Item.find_by_name_fragment('wuz')).to eq([@item, @item2])
    expect(Item.find_by_name_fragment('ZZzZ')).to eq([@item3])
  end

  it 'has a class method to search instances of itself by two price parameters' do
    @merchant = create(:merchant)
    @merchant2 = create(:merchant)
    @item = create(:item, merchant_id: @merchant.id, unit_price: 2.0)
    @item2 = create(:item, merchant_id: @merchant2.id, unit_price: 2.3)
    @item3 = create(:item, merchant_id: @merchant.id, unit_price: 2.5)
    @item4 = create(:item, merchant_id: @merchant2.id, unit_price: 2.6)
    @item5 = create(:item, merchant_id: @merchant.id, unit_price: 23.2)

    expect(Item.find_by_price(min_price: 2.4)).to eq([@item3, @item4, @item5])
    expect(Item.find_by_price(max_price: 2.4)).to eq([@item, @item2])
    expect(Item.find_by_price(min_price: 2.4, max_price: 2.55)).to eq([@item3])
  end

  describe "search method" do
    before(:each) do
      @merchant = create(:merchant)
      @merchant2 = create(:merchant)
      @item = create(:item, merchant_id: @merchant.id, unit_price: 2.0, name: "cheese")
      @item2 = create(:item, merchant_id: @merchant2.id, unit_price: 2.3, name: "cheesy delicious")
      @item3 = create(:item, merchant_id: @merchant.id, unit_price: 2.5, name: "PIIIIIE")
      @item4 = create(:item, merchant_id: @merchant2.id, unit_price: 2.6, name: "Seventy-Four Muffins")
      @item5 = create(:item, merchant_id: @merchant.id, unit_price: 23.2, name: "900 Candles")
    end

    it 'has a class method that can search both price and name' do
      expect(Item.search(name: "che")).to eq([@item, @item2])
      expect(Item.search(name: "00 C")).to eq([@item5])
      expect(Item.search(min_price: 2.5)).to eq([@item3, @item4, @item5])
      expect(Item.search(max_price: 2.3)).to eq([@item, @item2])
      expect(Item.search(min_price: 2.5, max_price: 2.6)).to eq([@item3, @item4])
      expect(Item.search(min_price: 2, name: "cheese")).to eq(false)

    end
  end
end
