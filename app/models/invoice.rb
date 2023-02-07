class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :invoice_items, dependent: :delete_all
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
end
