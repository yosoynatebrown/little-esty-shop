require 'rails_helper'

RSpec.describe "bulk_discounts/show", type: :view do
  before(:each) do
    @merchant = create(:merchant)
    @discount = create(:bulk_discount, merchant: @merchant)
  end

  it "should have the bulk discount's quantity threshold and percentage discount" do
    visit "/merchants/#{@merchant.id}/bulk_discounts/#{@discount.id}"

    expect(page).to have_content("#{(@discount.percent_discount * 100).to_i}%")
    expect(page).to have_content(@discount.quantity_threshold)
  end
end
