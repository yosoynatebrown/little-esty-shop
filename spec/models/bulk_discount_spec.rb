require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
   describe 'relationships' do
     it {should belong_to(:merchant).without_validating_presence}
   end
   describe 'validations' do
      subject { create(:bulk_discount) }
      it { should validate_presence_of(:name) }
      it { should validate_presence_of(:percent_discount) }
      it { should validate_presence_of(:quantity_threshold) }
  end

  it 'validates that discounts that will never be used cannot be made' do 
    @merchant = create(:merchant)
    @discount1 = create(:bulk_discount, merchant: @merchant, percent_discount: 0.20, quantity_threshold: 5)
    @discount2 = build(:bulk_discount, merchant: @merchant, percent_discount: 0.15, quantity_threshold: 10)
    @discount3 = build(:bulk_discount, merchant: @merchant, percent_discount: 0.20, quantity_threshold: 5)
    
    expect(@discount2.valid?).to eq(false)
    expect(@discount3.valid?).to eq(false)
  end
end
