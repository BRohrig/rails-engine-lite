class MerchantItemsFacade
  def self.find_all_by_merch_id(merch_id)
    if !Item.find_by_merch_id(merch_id).empty?
      Item.find_by_merch_id(merch_id)
    else
      Error.new("No Items Found for This Merchant", "Not Found", 404)
    end
  end



end