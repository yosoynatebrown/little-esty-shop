# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
BulkDiscount.destroy_all
100.times do
  BulkDiscount.create(
    name: "#{Faker::Company.bs.titleize} Discount",
    percent_discount: Faker::Number.between(from:0.0, to:0.5).round(2),
    quantity_threshold: Faker::Number.between(from: 1, to: 20),
    merchant: Merchant.order('RANDOM()').first)
end