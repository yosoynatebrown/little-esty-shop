require 'rails_helper'

RSpec.describe "bulk discounts index" do
  before(:each) do
  @merchant = create(:merchant)
  @discount1 = create(:bulk_discount, percent_discount: 0.1, quantity_threshold: 10, merchant: @merchant)
  @discount2 = create(:bulk_discount, percent_discount: 0.2 , quantity_threshold: 20, merchant: @merchant)
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

  it 'should have create discount buttons for each holiday' do 
    visit "merchants/#{@merchant.id}/bulk_discounts"

    expect(page).to have_button('Create Thanksgiving Day Discount')
    expect(page).to have_button('Create Christmas Day Discount')

    click_button "Create New Year's Day Discount"

    expect(current_path).to eq(new_bulk_discount_path(@merchant))

    click_button 'Create Bulk discount'

    expect(page).to have_content("30% 2")
    expect(page).to have_content("New Year's Day discount") #lower case discount ensures we are not testing button
  end

  it 'allows you to enter different information for holiday discount' do
    visit "merchants/#{@merchant.id}/bulk_discounts"

    click_button "Create Christmas Day Discount"

    expect(current_path).to eq(new_bulk_discount_path(@merchant))

    fill_in 'Percent discount', with: "0.7"
    fill_in 'Quantity threshold', with: "50"

    click_button 'Create Bulk discount'

    expect(page).to have_content("70% 50")
    expect(page).to have_content("Christmas Day discount")
  end

  it 'erases create holiday discount button after holiday discount already created' do 
    visit "merchants/#{@merchant.id}/bulk_discounts"

    click_button "Create Thanksgiving Day Discount"

    expect(current_path).to eq(new_bulk_discount_path(@merchant))

    click_button 'Create Bulk discount'

    expect(page).not_to have_button("Create Thanksgiving Day Discount")
    
    click_link 'View Discount'
    
    expect(page).to have_content('Quantity threshold: 2')
    expect(page).to have_content('Percent discount: 30%')
    expect(page).to have_content("Merchant: #{@merchant.name}")
  end
end