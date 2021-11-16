require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe 'relationships' do
    it {should have_many :invoices}
  end

  it 'counts how many successful transactions a customer has' do
    customer = create(:customer)
    invoice1 = create(:invoice, customer: customer)
    invoice2 = create(:invoice, customer: customer)
    invoice3 = create(:invoice, customer: customer)

    create(:transaction, result: 'success', invoice: invoice1)
    create(:transaction, result: 'success', invoice: invoice1)
    create(:transaction, result: 'success', invoice: invoice2)
    create(:transaction, result: 'failed', invoice: invoice2)
    create(:transaction, result: 'failed', invoice: invoice3)

    expect(customer.successful_transactions_count).to eq(3)
  end

  describe '#top_five_customers' do
    it 'returns the top five customers' do
      customer1, customer2, customer3, customer4, customer5, customer6  = create_list(:customer, 6)

      invoice1 = create(:invoice, customer: customer1)
      invoice2 = create(:invoice, customer: customer2)
      invoice3 = create(:invoice, customer: customer3)
      invoice4 = create(:invoice, customer: customer4)
      invoice5 = create(:invoice, customer: customer5)
      invoice6 = create(:invoice, customer: customer6)

      create_list(:transaction, 50, result: 'success', invoice: invoice1)
      create_list(:transaction, 40, result: 'success', invoice: invoice2)
      create_list(:transaction, 30, result: 'success', invoice: invoice3)
      create_list(:transaction, 20, result: 'success', invoice: invoice4)
      create_list(:transaction, 19, result: 'success', invoice: invoice5)

      expect(Customer.top_five_customers).to eq([ customer1,
                                                  customer2,
                                                  customer3,
                                                  customer4,
                                                  customer5
                                                  ])
    end
  end
end
