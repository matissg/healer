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

Product.insert_all(
  1000.times.map do
    {
      brand: Faker::Commerce.brand,
      name: Faker::Commerce.product_name,
      price: Faker::Commerce.price(range: 5..2000),
      stock: Faker::Number.between(from: 0, to: 1000),
      created_at: time_now,
      updated_at: time_now
    }
  end
)
