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

  it 'should have the next 3 holidays displayed' do
    visit "merchants/#{@merchant.id}/bulk_discounts"

    expect(page).to have_content("Upcoming Holidays")

    expect("Thanksgiving Day").to appear_before("Christmas Day")
    expect("Christmas Day").to appear_before("New Year's Day")
  end

  it 'should have a working new bulk discount link' do
    visit "merchants/#{@merchant.id}/bulk_discounts"

    click_link 'New Bulk Discount'

    expect(current_path).to eq(new_bulk_discount_path(@merchant))
  end

  it 'should have a working link to delete bulk discount' do
    visit "merchants/#{@merchant.id}/bulk_discounts"

    click_link "Delete #{@discount1.name}"

    expect(current_path).to eq("/merchants/#{@merchant.id}/bulk_discounts")
    expect(page).not_to have_content("#{@discount1.name}")
  end
end
