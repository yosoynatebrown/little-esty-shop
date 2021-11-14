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
      return (unit_price * quantity) if bulk_discount_applied.nil?
      
      (1 - bulk_discount_applied.percent_discount) * unit_price * quantity
    end

    def bulk_discount_id
      return 'No discount applied' if bulk_discount_applied.nil?
      bulk_discount_applied.id
    end
private
    def bulk_discount_applied
      merchant
      .bulk_discounts
      .where('quantity_threshold <= ?', quantity)
      .order(percent_discount: :desc)
      .limit(1)
      .first
    end
end
