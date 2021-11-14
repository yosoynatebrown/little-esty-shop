require 'rails_helper'

RSpec.describe "bulk_discounts/edit", type: :view do
  before(:each) do
    @merchant = create(:merchant)
    @discount = create(:bulk_discount, merchant: @merchant)
  end

   it "should have the bulk discount's attributes pre-populated" do
    visit "/merchants/#{@merchant.id}/bulk_discounts/#{@discount.id}/edit"

    expect(page).to have_field('Name', with: "#{@discount.name}")
    expect(page).to have_field('Percent discount', with: "#{@discount.percent_discount}")
    expect(page).to have_field('Quantity threshold', with: "#{@discount.quantity_threshold}")
   end

   it "should have the ability to modify content" do
    visit "/merchants/#{@merchant.id}/bulk_discounts/#{@discount.id}/edit"

    fill_in 'Name', with: "Children's Discount"
    fill_in 'Percent discount', with: "0.1"
    fill_in 'Quantity threshold', with: "15"

    click_button 'Save'

    expect(current_path).to eq("/merchants/#{@merchant.id}/bulk_discounts/#{@discount.id}")
    expect(page).to have_content("Children's Discount")
    expect(page).to have_content("10%")
    expect(page).to have_content("15")
   end
end
