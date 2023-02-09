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

  def self.find_by_name_fragment(fragment)
    Item.where('name ilike ?', "%#{fragment}%").order(:name)
  end

  def self.find_by_price(min_price: 0, max_price: 9_999_999)
    Item.where("unit_price BETWEEN #{min_price} AND #{max_price}")
  end
end
