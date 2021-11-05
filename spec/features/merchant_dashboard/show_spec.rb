require 'rails_helper'

RSpec.describe 'merchant dashboard show page' do
  before(:each) do
    @merchant = Merchant.first
    visit "/merchants/#{@merchant.id}/dashboard"
  end

  it 'should have name of merchant' do
    expect(page).to have_content(@merchant.name)
  end

  it 'should have links to the items/invoices indices' do
    has_link?("My Items")
    has_link?("My Invoices")
  end

  it 'should have top customers names in correct order' do
    expect(@merchant.top_customers.first.first_name).to appear_before(@merchant.top_customers.second.first_name)
    expect(@merchant.top_customers.second.first_name).to appear_before(@merchant.top_customers.last.first_name)
  end

  it 'should have items ready to ship in order from oldest to newest' do
    expect(page).to have_content("Items Ready to Ship")
    expect(page).to have_content(@merchant.shippable_items.first.name)
    expect(page).to have_content("Wednesday, March 07, 2012")
    expect(@merchant.shippable_items.first.name).to appear_before(@merchant.shippable_items.last.name)
  end
end
