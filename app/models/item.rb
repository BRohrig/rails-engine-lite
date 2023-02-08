class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :delete_all
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices

  def invoice_delete
    invoices.each do |invoice|
      Invoice.destroy(invoice.id) if invoice.items.include?(self) && invoice.items.distinct.count == 1
    end
  end
end
