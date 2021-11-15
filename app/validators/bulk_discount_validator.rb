class BulkDiscountValidator < ActiveModel::Validator
  def validate(record)
    merchant = Merchant.find(record.merchant_id)
    lower_threshold_discounts = merchant.bulk_discounts.where('bulk_discounts.quantity_threshold <= ?', record.quantity_threshold)
    better_discounts = lower_threshold_discounts.where('bulk_discounts.percent_discount >= ?', record.percent_discount)
    
    if better_discounts.any?
      record.errors.add(:bulk_discount, "Your discount will never be applied due to an existing better or equally good discount. Try again.")
    end
  end

end