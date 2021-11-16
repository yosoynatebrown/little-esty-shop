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

    click_button 'Update Bulk discount'

    expect(current_path).to eq("/merchants/#{@merchant.id}/bulk_discounts/#{@discount.id}")
    expect(page).to have_content("Children's Discount")
    expect(page).to have_content("10%")
    expect(page).to have_content("15")
   end

  describe 'new edit discount form' do
    context 'when valid information entered' do
      it 'should have a working form to create a new bulk discount' do
        visit "/merchants/#{@merchant.id}/bulk_discounts/#{@discount.id}/edit"

        fill_in 'Name', with: "Children's Discount"
        fill_in 'Percent discount', with: "0.1"
        fill_in 'Quantity threshold', with: "15"

        click_button 'Update Bulk discount'

        expect(current_path).to eq("/merchants/#{@merchant.id}/bulk_discounts/#{@discount.id}")
        expect(page).to have_content("Children's Discount")
        expect(page).to have_content("10%")
        expect(page).to have_content("15")
      end
    end
    context 'when no information entered' do
      it 'should display errors' do
        visit "/merchants/#{@merchant.id}/bulk_discounts/#{@discount.id}/edit"

        click_button 'Update Bulk discount'

        expect(page).to have_content("Error: Bulk discount Your discount will never be applied due to an existing better (or equally good) discount. Try again, dum-dum.")
      end
    end
  end
end
