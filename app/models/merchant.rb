class Merchant < ApplicationRecord
  has_many :items

  def self.find_by_name_fragment(fragment)
    Merchant.where('name ilike ?', "%#{fragment}%").order(:name).first
  end
end
