class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item
  delegate :merchant, to: :item
  delegate :customer, to: :invoice

  enum status: { "packaged" => 0,
                 "pending" => 1,
                 "shipped" => 2
               }

  scope :invoice_item_revenue, -> { sum("unit_price * quantity") }
  
  def self.invoice_item_price(invoice)
    find_by(invoice: invoice).unit_price
  end

  def self.invoice_item_quantity(invoice)
    find_by(invoice: invoice).quantity
  end

  def self.invoice_item_status(invoice)
    find_by(invoice: invoice).status
  end

  def discounted_revenue
    matching_discount = merchant
    .bulk_discounts
    .where('quantity_threshold <= ?', quantity)
    .order(percent_discount: :desc)
    .limit(1)

    return (unit_price * quantity) if matching_discount.empty?
    
    (1 - matching_discount.first.percent_discount) * unit_price * quantity
  end
end
