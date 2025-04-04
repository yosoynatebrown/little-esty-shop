require 'rails_helper'
# FactoryBot.find_definitions

RSpec.describe Invoice, type: :model do
  describe 'relationships' do
    it {should belong_to :customer}
    it {should have_many :transactions}
    it {should have_many :invoice_items}
    it {should have_many(:items).through(:invoice_items)}
  end

  describe 'class methods' do
    before :each do
      @invoice1 = create(:invoice, created_at: "2012-03-25 09:54:09 UTC")
      @invoice2 = create(:invoice, created_at: "2012-03-26 06:54:10 UTC")
      @invoice3 = create(:invoice, created_at: "2012-03-26 06:54:10 UTC")
      @completed_invoice = create(:invoice, created_at: "2011-03-25 09:54:09 UTC")
      @incomplete_invoice_1 = create(:invoice, created_at: "2011-03-25 09:54:09 UTC")
      @incomplete_invoice_2 = create(:invoice, created_at: "2011-03-25 09:54:09 UTC")
    end

    describe '.highest_date' do
      it 'should return the date with the highest number of invoices' do
        expect(Invoice.highest_date).to eq('2012-03-27 13:54:28.000000000 +0000')
      end
    end

    describe '.incomplete_invoices' do
      it 'returns all incomplete_invoices' do
        invoice_item1 = create(:invoice_item, invoice: @completed_invoice, status: 2)
        invoice_item2 = create(:invoice_item, invoice: @incomplete_invoice_1, status: 0)
        invoice_item2 = create(:invoice_item, invoice: @incomplete_invoice_2, status: 1)
        expect(Invoice.incomplete_invoices).to include(@incomplete_invoice_1, @incomplete_invoice_2)
      end
    end
  end

  describe 'instance methods' do
    before :each do
      @merchant = create(:merchant)
      @item1, @item2, @item3 = create_list(:item, 3, merchant: @merchant)
      @invoice = create(:invoice)
      @discount = create(:bulk_discount, merchant: @merchant, percent_discount: 0.2, quantity_threshold: 12)

      @invoice_item1 = create(:invoice_item, invoice: @invoice, item: @item1, unit_price: 1, quantity: 10)
      @invoice_item2 = create(:invoice_item, invoice: @invoice, item: @item2, unit_price: 2, quantity: 10)
      @invoice_item3 = create(:invoice_item, invoice: @invoice, item: @item3, unit_price: 1, quantity: 20)    end

    describe '#total_revenue' do
      it 'returns the revenue of the invoices belonging to an invoice' do
        expect(@invoice.total_revenue).to eq 50
      end
    end

    describe '#discounted_invoice_revenue' do
      it 'returns the revenue of the invoices belonging to an invoice' do
        expect(@invoice.discounted_invoice_revenue).to eq 46
      end
    end
  end
end
