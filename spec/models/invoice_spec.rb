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
    end

    describe '#highest_date' do
      it 'should return the date with the highest number of invoices' do
        expect(Invoice.highest_date).to eq(@invoice2.created_at)
      end
    end
  end

  describe 'instance methods' do
    before :each do
      @invoice = create(:invoice)

      @invoice_item1 = create(:invoice_item, invoice: @invoice, unit_price: 1, quantity: 10)
      @invoice_item2 = create(:invoice_item, invoice: @invoice, unit_price: 2, quantity: 10)
    end

    describe '.invoice_revenue' do
      it 'returns the revenue of the invoices belonging to an invoice' do
        expect(@invoice.invoice_revenue).to eq 30
      end
    end
  end
end
