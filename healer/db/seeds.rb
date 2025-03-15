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

user_ids = User.pluck(:id)

Order.insert_all(
  100.times.map do
    {
      user_id: user_ids.sample,
      total: rand(100..1000),
      created_at: time_now,
      updated_at: time_now
    }
  end
)
