require 'rails_helper'

RSpec.describe Item, type: :model do
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
    before :each do
      @merchant = Merchant.create!(name: "Angela's Shop")
      @item_1 = @merchant.items.create!(name: "Jade Rabbit", description: "25mmx25mm hand carved jade rabbit", unit_price: 2500)
      @item_2 = @merchant.items.create!(name: "Wooden Rabbit", description: "1mmx1mm", unit_price: 50000)
      @item_3 = @merchant.items.create!(name: "Bob the Skull", description: "a quirky little guy", unit_price: 100, status: 1)
    end

    describe '#enabled' do
      it 'returns a collection of enabled items' do
        expect(Item.enabled).to eq([@item_3])
      end
    end

    describe '#disabled' do
      it 'returns a collection of disabled items' do
        expect(Item.disabled).to eq([@item_1, @item_2])
      end
    end
  end
end
