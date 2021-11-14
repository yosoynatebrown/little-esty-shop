require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe 'relationships' do
    it {should belong_to :item}
    it {should belong_to :invoice}
  end
    before :each do
      @merchant = create(:merchant)
      @item1, @item2, @item3 = create_list(:item, 3, merchant: @merchant)
      @invoice = create(:invoice)
      @discount1 = create(:bulk_discount, merchant: @merchant, percent_discount: 0.15, quantity_threshold: 11)
      @discount2 = create(:bulk_discount, merchant: @merchant, percent_discount: 0.2, quantity_threshold: 12)
      @discount3 = create(:bulk_discount, merchant: @merchant, percent_discount: 0.3, quantity_threshold: 20)

      @invoice_item1 = create(:invoice_item, invoice: @invoice, item: @item1, unit_price: 1, quantity: 10)
      @invoice_item2 = create(:invoice_item, invoice: @invoice, item: @item2, unit_price: 2, quantity: 10)
      @invoice_item3 = create(:invoice_item, invoice: @invoice, item: @item3, unit_price: 1, quantity: 20)
    end
 describe 'instance methods' do

  describe '#discounted_revenue' do
      it "calculates discounted_revenue and only applies the highest discount" do
        expect(@invoice_item3.discounted_revenue).to eq(14)
      end

      it "doesn't apply discount when invoice_item does not qualify" do
        expect(@invoice_item2.discounted_revenue).to eq(20)
      end
    end

  describe '#bulk_discount_id' do
    it "provides the bulk discount id for discount applied to the invoice item" do 
        expect(@invoice_item3.bulk_discount_id).to eq(@discount3.id)
        expect(@invoice_item2.bulk_discount_id).to eq('No discount applied')
    end
  end
end
end
