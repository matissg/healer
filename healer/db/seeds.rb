# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require "faker"

time_now = Time.current

puts "\n== Inserting users =="

User.insert_all(
  20.times.map do
    name = ::Faker::Name.name
    {
      name: name,
      email: "#{name.gsub(" ", "").underscore}@example.com",
      created_at: time_now,
      updated_at: time_now
    }
  end
)

puts "\n== Inserting orders =="

user_ids = User.pluck(:id)

Order.insert_all(
  100.times.map do
    quantity = rand(1..10)
    price = rand(100..1000)
    total = quantity * price

    {
      user_id: user_ids.sample,
      product_catalog_guid: ::Faker::Number.number(digits: 10),
      product_name: ::Faker::Commerce.product_name,
      quantity: quantity,
      price: price,
      total: total,
      created_at: time_now,
      updated_at: time_now
    }
  end
)
