class MerchantItemsFacade
  def self.find_all_by_merch_id(merch_id)
    Merchant.find(merch_id).items
  end
end
