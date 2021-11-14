require 'rails_helper'
# FactoryBot.find_definitions

RSpec.describe "admin invoice show page" do
  before :each do
    @customer = create(:customer)
    @merchant1 = create(:merchant)
    @merchant2 = create(:merchant)

    @invoice = create(:invoice, customer: @customer, created_at: "2012-03-25 09:54:09 UTC", status: 0)

    @item1 = create(:item, merchant: @merchant1)
    @item2 = create(:item, merchant: @merchant1)
    @item3 = create(:item, merchant: @merchant2)
    @item4 = create(:item, merchant: @merchant2)

    @invoice_item1 = create(:invoice_item, invoice: @invoice, item: @item1, quantity: 1, unit_price: 1000)
    @invoice_item2 = create(:invoice_item, invoice: @invoice, item: @item2, quantity: 10, unit_price: 200)
    @invoice_item3 = create(:invoice_item, invoice: @invoice, item: @item3, quantity: 4, unit_price: 1000)
    @invoice_item4 = create(:invoice_item, invoice: @invoice, item: @item4, quantity: 10, unit_price: 200)
  end

  it 'show invoice information' do
    visit "/admin/invoices/#{@invoice.id}"

    expect(page).to have_content(@invoice.id)
    expect(page).to have_content(@invoice.status)

    expect(page).to have_content("Sunday, March 25, 2012")

    expect(page).to have_content(@customer.first_name)
    expect(page).to have_content(@customer.last_name)
  end

  it 'describes the items for the invoice' do
    visit "/admin/invoices/#{@invoice.id}"

    within('#item-0') do
      expect(page).to have_content(@item1.name)
      expect(page).to have_content(@invoice_item1.quantity)
      expect(page).to have_content("$10.00")

      expect(page).to_not have_content(@item2.name)
    end
  end

  it 'displays the total revenue for the invoice' do
    visit "/admin/invoices/#{@invoice.id}"

    expect(page).to have_content("Total Revenue: $90.00")
  end

  it 'has a dropdown form to update the status' do
    visit "/admin/invoices/#{@invoice.id}"

    within('#change_status_section') do
      expect(page).to have_content('Status: cancelled')
      expect(page).to have_content('cancelled completed in progress')
      expect(page).not_to have_content('Status: in progress')
      select('in progress', from: 'status')
      expect(page).to have_select('status', selected: 'in progress')
      click_button "Submit"
      expect(page).to have_content('Status: in progress')
    end
  end

  it 'has the discounted revenue' do
    @discount1 = create(:bulk_discount, merchant: @merchant1, percent_discount: 0.2, quantity_threshold: 5)
    @discount2 = create(:bulk_discount, merchant: @merchant2, percent_discount: 0.3, quantity_threshold: 5)

    visit "/admin/invoices/#{@invoice.id}"

      
    expect(page).to have_content("Discounted Revenue: $80.00")
  end
end
