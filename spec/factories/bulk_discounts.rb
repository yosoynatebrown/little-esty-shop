FactoryBot.define do
  factory :bulk_discount do
    merchant
    percent_discount { Faker::Number.decimal(l_digits: 0, r_digits: 2) }
    quantity_threshold { Faker::Number.number(digits: 2) }
    name { "#{Faker::Company.bs.titleize} Discount" }
  end
end
