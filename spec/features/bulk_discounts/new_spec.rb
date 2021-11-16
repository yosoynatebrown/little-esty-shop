require 'rails_helper'

RSpec.describe "bulk discount new page", type: :view do
  before(:each) do
    @merchant = create(:merchant)
  end
  describe 'new bulk discount form' do
    context 'when valid information entered' do
      it 'should have a working form to create a new bulk discount' do
        visit new_bulk_discount_path(@merchant)

        fill_in 'Name', with: "Senior Discount"
        fill_in 'Percent discount', with: "0.2"
        fill_in 'Quantity threshold', with: "10"

        click_button 'Create Bulk discount'

        expect(current_path).to eq(bulk_discounts_path(@merchant))
        expect(page).to have_content("Senior Discount")
        expect(page).to have_content("Bulk discount was successfully created.")
      end
    end
    context 'when no information entered' do
      it 'should display errors' do
        visit new_bulk_discount_path(@merchant)

        click_button 'Create Bulk discount'

        expect(current_path).to eq(new_bulk_discount_path(@merchant))
        expect(page).to have_content("Bulk discount was successfully created.")
      end
    end
  end
end
