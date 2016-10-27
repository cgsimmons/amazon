require 'faker'

FactoryGirl.define do
  factory :product do
    sequence(:title) { |n| "#{Faker::Commerce.product_name} #{n}"}
    description Faker::Company.catch_phrase
    price {10 + rand(100)}
    sale_price {rand(price)}
    user
    category
  end
end

#
# t.string   "title"
# t.text     "description"
# t.float    "price"
# t.float    "sale_price"
# t.datetime "created_at",  null: false
# t.datetime "updated_at",  null: false
