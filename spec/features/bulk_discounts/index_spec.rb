require 'rails_helper'

RSpec.describe "bulk discounts index" do
  before(:each) do
  @merchant = create(:merchant)
  @discount1, @discount2 = create_list(:bulk_discount, 2, merchant: @merchant)
  end

  it 'should include all bulk discounts with links to BD show page' do 
    visit "merchants/#{@merchant.id}/bulk_discounts"

    expect(page).to have_link("#{@discount1.name}")
    expect(page).to have_link("#{@discount2.name}")
  end

  it 'should display percentage discount and quantity thresholds' do 
    visit "merchants/#{@merchant.id}/bulk_discounts"

    expect(page).to have_content("#{(@discount1.percent_discount * 100).to_i}")
    expect(page).to have_content("#{@discount1.quantity_threshold}")

    expect(page).to have_content("#{(@discount2.percent_discount * 100).to_i}")
    expect(page).to have_content("#{@discount2.quantity_threshold}")
  end
end
