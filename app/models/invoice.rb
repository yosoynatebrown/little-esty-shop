class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items

  enum status: { "cancelled" => 0,
                 "completed" => 1,
                 "in progress" => 2
               }
  scope :incomplete_invoices, -> { joins(:invoice_items)
                                  .where(invoice_items: {status: ['0','1']})
                                  .group(:id)
                                  .order(:created_at ) }

  scope :highest_date, -> { select("invoices.created_at")
                            .order(created_at: :desc)
                            .group(:created_at)
                            .order("invoices.count DESC")
                            .first
                            .created_at }

  def invoice_revenue
    wip = invoice_items.invoice_item_revenue
  end

  def discounted_invoice_revenue
    wip = items.joins(merchant: :bulk_discounts)
                 .select('invoice_items.quantity, merchants.id, bulk_discounts.*, MAX(bulk_discounts.quantity_threshold) AS max_quantity_threshold')
                 .group('bulk_discounts.id')
                 .where('invoice_items.quantity >= max_quantity_threshold')
  end
end
