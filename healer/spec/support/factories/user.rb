FactoryBot.define do
  factory :user, class: "User" do
    sequence(:name) { |n| "#{n}_user" }
    sequence(:email) { |n| "#{n}.user@example.com" }
  end
end
