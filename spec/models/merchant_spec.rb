# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Merchant, type: :model do
  it { should have_many(:items) }

  it 'has a class method to search for instances of itself by a case insensitive name fragment alphabetically' do
    @merchant = create(:merchant, name: 'Ye Olde Store')
    @merchant2 = create(:merchant, name: 'Ye Younge Store')
    @merchant3 = create(:merchant, name: 'A Store Yo')
    @merchant4 = create(:merchant, name: 'Yup, Still a Store')

    expect(Merchant.find_by_name_fragment('Ye')).to eq([@merchant, @merchant2])
    expect(Merchant.find_by_name_fragment('store')).to eq([@merchant3, @merchant, @merchant2, @merchant4])
    expect(Merchant.find_by_name_fragment('l a')).to eq([@merchant4])
  end
end
