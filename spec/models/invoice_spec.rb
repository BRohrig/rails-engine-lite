# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Invoice, type: :model do
  it { should belong_to(:customer) }
  it { should have_many(:invoice_items) }
  it { should have_many(:items).through(:invoice_items) }
  it { should have_many(:merchants).through(:items) }
end
