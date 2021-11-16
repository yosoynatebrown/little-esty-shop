require 'rails_helper'
# FactoryBot.find_definitions

RSpec.describe Item, type: :model do
  before :each do
    @merchant = create(:merchant)

    @item1 = create(:item, merchant: @merchant)
    @item2 = create(:item, merchant: @merchant)
    @item3 = create(:item, status: 1, merchant: @merchant)
    @item4 = create(:item, merchant: @merchant)
    @item5 = create(:item, merchant: @merchant)
    @item6 = create(:item, merchant: @merchant)

    @invoice = create(:invoice)

    @transaction = create(:transaction, result: 'success', invoice: @invoice)

    @invitem1 = create(:invoice_item, quantity: 1000, unit_price: 100000, status:"packaged", invoice: @invoice, item: @item1)
    @invitem2 = create(:invoice_item, quantity: 1000, unit_price: 200000, invoice: @invoice, item: @item2)
    @invitem3 = create(:invoice_item, quantity: 1000, unit_price: 300000, invoice: @invoice, item: @item3)
    @invitem4 = create(:invoice_item, quantity: 1000, unit_price: 400000, invoice: @invoice, item: @item4)
    @invitem5 = create(:invoice_item, quantity: 1000, unit_price: 500000, invoice: @invoice, item: @item5)
    @invitem6 = create(:invoice_item, quantity: 1000, unit_price: 600000, invoice: @invoice, item: @item6)
  end
  describe 'relationships' do
    it {should belong_to :merchant}
    it {should have_many :invoice_items}
    it {should have_many(:invoices).through(:invoice_items)}
  end

  describe 'validations' do
    it {should validate_presence_of(:name)}
    it {should validate_presence_of(:description)}
    it {should validate_presence_of(:unit_price)}
  end

  describe 'class methods' do
    describe '.enabled' do
      it 'returns a collection of enabled items' do
        expect(Item.enabled).to eq([@item3])
      end
    end

    describe '.disabled' do
      it 'returns a collection of disabled items' do
        expect(Item.disabled).to include(@item1)
        expect(Item.disabled).to include(@item2)
      end
    end

    describe '#top_five_items' do
      it 'returns the top five items by revenue' do
        expect(Item.top_five_items).to eq [ @item6,
                                            @item5,
                                            @item4,
                                            @item3,
                                            @item2
                                          ]
      end
    end
  end

  describe 'instance methods' do
    describe '#invoice_item_price' do
      it 'should give the price the item sold at' do

        expect(@item1.invoice_item_price(@invoice)).to eq(@invitem1.unit_price)
      end
    end

    describe '#invoice_item_quantity' do
      it 'should give the quantity of the item sold' do

        expect(@item1.invoice_item_quantity(@invoice)).to eq(@invitem1.quantity)
      end
    end

    describe '#invoice_item_status' do
      it 'should return the status of the invoice' do
        expect(@item1.invoice_item_status(@invoice)).to eq("packaged")
      end
    end

    describe '#invoice_item' do
      it 'should give invoice item corresponding to the given item and invoice' do
        expect(@item1.invoice_item(@invoice).id).to eq(@invitem1.id)
      end
    end
  end
end
