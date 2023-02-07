class Item < ApplicationRecord
  belongs_to :merchant

  def self.find_by_merch_id(id)
    self.where(merchant_id: id)
  end
end
